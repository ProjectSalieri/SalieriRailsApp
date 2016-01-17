class DocCategoryType < ActiveRecord::Base

  has_many :words
  has_many :doc_categories

  def self.type_genre ; 	return DocCategoryType.find_by({:name_en => "Genre"}) 	; end
  def self.type_emotion ; 	return DocCategoryType.find_by({:name_en => "Emotion"}) ; end
end
