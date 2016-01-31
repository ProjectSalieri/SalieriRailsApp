class DocCategoryInfo < ActiveRecord::Base

  belongs_to :word, :autosave => true
  belongs_to :doc_category, :autosave => true

  before_create do
    self.appear_count = 0
  end

  # 出現カウントの更新
  def self.update_appear_counts(category_type_id, category_id, word_names)
    words = Word.where(:doc_category_type_id => category_type_id).where("name in (#{word_names.map{ |w| "\'#{w}\'" }.join(',')})").all
    category_ids = DocCategory.where(:doc_category_type_id => category_type_id).pluck(:id)

    words.each { |word|
      next if word_names.include?(word.name)

      # 他のカテゴリのDocCategoryInfoがなければ一緒に生成
      update_info = nil
      category_ids.each { |cat_id|
        info = DocCategoryInfo.find_or_create_by({doc_category_id: cat_id, word_id: word.id})
        update_info = info if category_id == cat_id
      }
    
      update_info.appear_count += word_names.count(word.name)
      update_info.save
    }
  end

end
