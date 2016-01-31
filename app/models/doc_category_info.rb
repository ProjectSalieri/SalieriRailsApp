class DocCategoryInfo < ActiveRecord::Base

  belongs_to :word, :autosave => true
  belongs_to :doc_category, :autosave => true

  before_create do
    self.appear_count = 0
  end

  # 出現カウントの更新
  def self.update_appear_counts(category_type_id, category_id, word_names)
    word_names.each { |w| Word.find_or_create_by({:name => w, :doc_category_type_id => category_type_id}) } # @fixme? 高速化
    word_infos = Word.where(:doc_category_type_id => category_type_id).where("name in (#{word_names.map{ |w| "\'#{w}\'" }.join(',')})").pluck(:id, :name)
    category_ids = DocCategory.where(:doc_category_type_id => category_type_id).pluck(:id)

    word_infos.each { |word_info|
      word_name = word_info[1]
      next unless word_names.include?(word_name)

      # 他のカテゴリのDocCategoryInfoがなければ一緒に生成
      update_info = nil
      category_ids.each { |cat_id|
        info = DocCategoryInfo.find_or_create_by({doc_category_id: cat_id, word_id: word_info[0]})
        update_info = info if category_id == cat_id
      }
    
      update_info.appear_count += word_names.count(word_name)
      update_info.save
    }
  end

end
