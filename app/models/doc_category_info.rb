class DocCategoryInfo < ActiveRecord::Base

  belongs_to :word, :autosave => true
  belongs_to :doc_category, :autosave => true

  before_create do
    self.appear_count = 0
  end

  # 出現カウントの更新
  def self.update_appear_count(category_type_id, category_id, word_name)
    category_ids = DocCategory.where(:doc_category_type_id => category_type_id).pluck(:id)
    word = Word.find_or_create_by({name: word_name, doc_category_type_id: category_type_id})

    # 他のカテゴリのDocCategoryInfoがなければ一緒に生成
    update_info = nil
    category_ids.each { |cat_id|
      info = DocCategoryInfo.find_or_create_by({doc_category_id: cat_id, word_id: word.id})
      update_info = info if category_id == cat_id
    }
    
    update_info.appear_count += 1
    update_info.save
  end
end
