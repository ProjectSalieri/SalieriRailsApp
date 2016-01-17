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

    post_msg = "[Salieri]感想機能はまだ。自主的にニュース読むようにしたい\n#{news_info[:title]}\n#{url}"
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
  
  # ジャンルカテゴライズのために形態素解析
  def parse_for_genre_categorize(document)
    ret = []

    noun_list = ["名詞", "動詞"]

    t = parse(document)
    t.each { |m|
      features = m.feature.split(",")
      noun = features[0]
      next if noun_list.include?(noun) == false
      next if noun == "名詞" && features[1] == "代名詞"

      base = features[6]
      next if base == "*"
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

    parse_result.each { |w|
      word = Word.find_or_create_by({name: w, doc_category_type_id: category_type.id})
      category_info = DocCategoryInfo.find_or_create_by({doc_category_id: category.id, word_id: word.id})
      appear_count = category_info.appear_count == nil ? 1 : category_info.appear_count + 1
      category_info.appear_count = appear_count
      category_info.save # categoryのdoc_category_infosを直接変更しないと、findするたびに新しいインスタンスになってしまうのでこまめなsaveが必要になってる
    }

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
    end

    # 単語を数値に変換
    value_array = []
    words = Word.where(:doc_category_type_id => category_type.id)
    parse_results.each { |result|
      word = words.find_by({name: result})
      value_array << word.value if word != nil && word.value != nil
    }

    cmd = "python #{File.join(Rails.root.to_s, 'lib', 'nlp', 'CategoryPredictor.py')}"
    value_array.each { |value| cmd += " #{value}" }
#    3000.times { |i| cmd += " #{i}" }
    prediction = `#{cmd}`

    return prediction
  end

  # コーパス再整理
  def corpus_arrange
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
  end

  def parse(document)
    if @tagger == nil
      @tagger = init_tagger
    end

    return @tagger.parse(document)
  end

  private

  # taggerの初期化
  def init_tagger
    ipadic_path = File.join(Rails.root.to_s, "lib", "nlp", "ipadic")

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
end
