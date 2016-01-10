class Salieri < ActiveRecord::Base

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
      category_info.save
    }

    category.save
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
