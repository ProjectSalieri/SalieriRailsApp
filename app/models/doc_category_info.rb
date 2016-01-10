class DocCategoryInfo < ActiveRecord::Base

  belongs_to :word, :autosave => true
  belongs_to :doc_category, :autosave => true
end
