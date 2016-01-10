class DocCategoryInfo < ActiveRecord::Base

  belongs_to :word
  belongs_to :doc_category
end
