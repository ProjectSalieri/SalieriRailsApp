require 'spec_helper'

describe Salieri do
  before do
    @salieri = Salieri.new()
  end

  it 'genre_categorize process' do
    # parseした結果
    document = "私はサッカーが好きです。ボールを蹴りながら走ると楽しいし、スッキリします。スポーツでサッカーがいい"

    parse_result = @salieri.parse_for_genre_categorize(document)
    expect(parse_result).to eq ["サッカー", "好き", "ボール", "蹴る", "走る", "する", "スポーツ", "サッカー"]

    # 学習用にcorpus更新
    category_type_name_en = "DocCategorize"
    category_name_en = "sports"
    category = DocCategory.find_by({name_en: category_name_en})
    category_type = DocCategoryType.find_by({name_en: category_type_name_en})

    parse_result_cnt = {}
    parse_result.each { |word|
      parse_result_cnt[word] = 0 if parse_result_cnt.key?(word) == false
      parse_result_cnt[word] += 1
    }

    @salieri.update_appear_count(parse_result, category_type_name_en, category_name_en)

    # ひとまず指定カテゴリだけの数が増えているのと、カテゴリと単語指定した出現回数がparse_resultと一致している簡易テスト
    categories = DocCategory.where(:category_type_id => category_type.id)
    categories.each { |category| expect(category.appear_count).to eq (category.name_en == category_name_en ? 1 : 0) }
    parse_result_cnt.each { |k, v|
      word = Word.find_by({name: k, category_type_id: category_type.id})
      category_info = CategoryInfo.find_by(category_id: category.id, word_id: word.id)
      expect(category_info.appear_count).to eq v
    }
  end

end
