class Salieri < ActiveRecord::Base

  include Data::MicrosoftNewsCrawler
  
  def self.twitter_account_name ; return "projectsalieri" ; end

  # ニュースを読む
  def read_news
    # @todo カテゴリの選択を好みに応じて
    news_category = DEFAULT_CATEGORIES.sample()[:name_en]
    results = MicrosoftNewsFunction.get_url_catalog(news_category)

    # @todo 一覧から選択する処理好みに応じて
    url = results.sample[:url]
    # 既読ニュース以外を選択
    if Salieri::SalieriStringMemory.is_already_read(url)
      url = nil
      results.each { |result|
        tmp_url = result[:url]
        next if Salieri::SalieriStringMemory.is_already_read(tmp_url)
        url = tmp_url
        break
      }
    end

    # 既読のニュースしかなかった
    return "既読ニュースしかなかった" if url == nil

    news_info = MicrosoftNewsFunction.get_news(url)

    prediction = predict_category(news_info[:content], DocCategoryType.type_genre.name_en)

    post_msg = "[Salieri]#{prediction}の話題?\n#{news_info[:title]}\n#{url}"
    if Rails.env.production? # @note production以外はtwitterの投稿を控える
      salieri_user = TwitterAccount.find_by({:name_en => Salieri.twitter_account_name})
      salieri_user.post(post_msg) 
    end

    # 既読チェック
    Salieri::SalieriStringMemory.mark_read(url)

    # 学習
    parse_result = self.parse_for_genre_categorize(news_info[:content])
    self.update_appear_count(parse_result, DocCategoryType.type_genre.name_en, news_category)

    return post_msg
  end

  def read_twitter_timeline
    document = "経済の話題は楽しくない思う #嫌い #経済"
    hash_tags = TwitterAccount.extract_hash_tags(document)
    hash_tags.each { |tag| document.gsub!(" #{tag}", "") } # ハッシュタグを除去

    prediction = predict_category(document, DocCategoryType.type_emotion.name_en)
    post_msg = "[Salieri]#{prediction}な話題?\n"

    # ハッシュタグをもとに学習
    emotion_categories = DocCategory.where(:doc_category_type_id => DocCategoryType.type_emotion.id).where("name_jp in (#{hash_tags.map{ |t| "'#{t}'"}.join(',')})")
    if emotion_categories.blank? == false
      parse_result = self.parse_for_emotion_categorize(document)
      self.update_appear_count(parse_result, DocCategoryType.type_emotion.name_en, emotion_categories.first.name_en)
    end

    return post_msg
  end
  
  # ジャンルカテゴライズのために形態素解析
  def parse_for_genre_categorize(document)
    ret = []

    noun_list = ["名詞", "動詞"]
    invalid_words = ["*"]

    t = parse(document)
    t.each { |m|
      features = m.feature.split(",")
      noun = features[0]
      next if noun_list.include?(noun) == false
      next if noun == "名詞" && features[1] == "代名詞"

      base = features[6]
      next if invalid_words.include?(base)
      ret << base
    }
    return ret
  end

  # 感情カテゴライズのために形態素解析
  def parse_for_emotion_categorize(document)
    ret = []

    noun_list = ["名詞", "形容詞", "助動詞"]
    invalid_words = ["*"]

    t = parse(document)
    t.each { |m|
      features = m.feature.split(",")
      noun = features[0]
      next if noun_list.include?(noun) == false
      next if noun == "名詞" && features[1] == "代名詞"

      base = features[6]
      next if invalid_words.include?(base)
      if noun == "助動詞"
        next if base != "ない"
        ret[-1] = ret[-1] + base  # 直前の単語の否定版
        next
      end
      ret << base
    }
    return ret
  end

  # corpusの出現頻度情報更新
  def update_appear_count(parse_result, category_type_name_en, category_name_en)
    category_type = DocCategoryType.find_by({name_en: category_type_name_en})
    category = DocCategory.find_by({name_en: category_name_en})

    # カテゴリの出現頻度更新
    category.appear_count += 1

    DocCategoryInfo.update_appear_counts(category_type.id, category.id, parse_result)
    category.save
  end

  # カテゴリ推定
  def predict_category(document, category_type_name_en)
    category_type = nil
    parse_result = nil

    # 形態素解析
    if DocCategoryType.type_genre.name_en == category_type_name_en
      category_type = DocCategoryType.type_genre
      parse_results = parse_for_genre_categorize(document)
    elsif DocCategoryType.type_emotion.name_en == category_type_name_en
      category_type = DocCategoryType.type_emotion
      parse_results = parse_for_emotion_categorize(document)
    end

    # 単語を数値に変換
    value_array = []
    word_infos = Word.where(:doc_category_type_id => category_type.id).where("name in (#{parse_results.map{ |w| "'#{w}'"}.join(',')})").pluck(:name, :value)
    word_infos.each { |word_info|
      word_name = word_info[0]
      next unless parse_results.include?(word_name)
      value_array << word_info[1] if word_info[1] != nil
    }

    cmd = "python #{File.join(Salieri.nlp_dir, 'ExecMultinominalModelNaiveBayes.py')} --predict --category_type #{category_type_name_en}"
    value_array.each { |value| cmd += " #{value}" }
    predict_category_name_en = `#{cmd}`.split("\n")[0]
    return "なんの話題かわからない" unless $? == 0
    prediction = DocCategory.find_by({:name_en => predict_category_name_en, :doc_category_type_id => category_type.id}).name_jp

    return prediction
  end

  # 保存データの整理
  def arrange_memory
    # StringMemoryの整理

    # コーパスの整理
    arrange_corpus
  end

  def parse(document)
    if @tagger == nil
      @tagger = Salieri.init_tagger
    end

    return @tagger.parse(document)
  end

  private

  def self.nlp_dir
    return File.join(Rails.root.to_s, "lib", "nlp")
  end

  # taggerの初期化
  def self.init_tagger
    ipadic_path = File.join(Salieri.nlp_dir, "ipadic")

    # 解凍済みファイルは重いので初回のみ解凍
    if File.exist?(ipadic_path) == false
      require "zip/zip"
      Zip::ZipFile.open("#{ipadic_path}.zip") do |zip|
        zip.each do |entry|
          # { true } は展開先に同名ファイルが存在する場合に上書きする指定
          zip.extract(entry, File.join(File.dirname(ipadic_path), entry.to_s)) { true }
          end
      end
    end

    return Igo::Tagger.new(ipadic_path)
  end

  # コーパス再整理
  def arrange_corpus
    # 出現頻度が低いwordの削除
    prev_month = Time.now.prev_month
    DocCategoryType.all.each { |category_type|
      doc_categories = DocCategory.where(:doc_category_type_id => category_type.id)
      doc_category_ids = doc_categories.pluck(:id).join(',')

      words = Word.where(:doc_category_type_id => category_type.id).includes(:doc_category_infos).where("doc_category_infos.updated_at <= ?", prev_month).references(:doc_category_infos)
      words.each { |word|
        # 一つでも最近更新されていれば削除しない
        next unless word.doc_category_infos.where("updated_at > ?", prev_month).blank?
        # 全てのカテゴリで一月以上更新されてない単語は削除
        word.doc_category_infos.each { |del_info| del_info.destroy }
        word.destroy
      }
    }

    # 情報量計算

    # valueの再割り当て ひとまず、シンプルに各CategoryType毎に順に番号振り
    # @todo 情報量を元に不要な単語削除
    DocCategoryType.all.each { |category_type|
      words = Word.where(:doc_category_type_id => category_type.id)
      cnt = 0
      words.each { |word|
        word.value = cnt
        word.save
        cnt += 1
      }
    }

    # 再学習
    cmd = "python #{File.join(Salieri.nlp_dir, 'ExecMultinominalModelNaiveBayes.py')} --learn"
    `#{cmd}`

  end
end
