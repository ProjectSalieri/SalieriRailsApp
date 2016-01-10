# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

begin
  doc_category_type = DocCategoryType.find_or_create_by({:name_jp => "ジャンル分類", :name_en => "GenreCategorize"})
rescue => e
  abort("DocCategoryType失敗\n#{e.backtrace().join("\n")}")
end
