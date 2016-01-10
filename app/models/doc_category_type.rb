class DocCategoryType < ActiveRecord::Base

  has_many :words
  has_many :doc_categories
end
