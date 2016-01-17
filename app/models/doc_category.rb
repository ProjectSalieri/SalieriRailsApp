class DocCategory < ActiveRecord::Base

  belongs_to :doc_category_type
  has_many :doc_category_infos

  scope :where_type_genre, -> { where(:doc_category_type_id => DocCategoryType.type_genre.id) }
end
