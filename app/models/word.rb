class Word < ActiveRecord::Base

  belongs_to :doc_category_type
  has_many :doc_category_infos

  scope :where_valid_word, ->(category_type_id) { where(:doc_category_type_id => category_type_id).where("value IS NOT NULL") }
end
