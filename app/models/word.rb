class Word < ActiveRecord::Base

  belongs_to :doc_category_type
  has_many :doc_category_infos
end
