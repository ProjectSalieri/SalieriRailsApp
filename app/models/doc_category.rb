class DocCategory < ActiveRecord::Base

  belongs_to :category_type
  has_many :doc_category_infos, :autosave => true
end
