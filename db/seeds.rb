# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# DocCategoryType / DocCategory
begin
  doc_category_type_init_info = [
                            {:name_jp => "ジャンル分類", :name_en => "GenreCategorize"},
                           ]

  doc_category_init_info = {
    "GenreCategorize" => [ 
                          {name_jp: "テクノロジー", name_en: "techandscience", 	appear_count: 0},
                          {name_jp: "エンタメ", 	name_en: "entertainment", 	appear_count: 0},
                          {name_jp: "経済", 		name_en: "money", 			appear_count: 0},
                          {name_jp: "スポーツ", 	name_en: "sports", 			appear_count: 0},
                         ]
  }

  doc_category_type_init_info.each { |info|
    doc_category_type = DocCategoryType.find_or_create_by(info)    
  }
  
  doc_category_init_info.each { |type, init_infos|
    doc_category_type = DocCategoryType.find_by({name_en: type})
    init_infos.each { |init_info|
      doc_category = DocCategory.find_or_create_by(init_info.merge({:doc_category_type_id => doc_category_type.id}))
    }
  }

  
rescue => e
  abort("DocCategoryType失敗\n#{e.backtrace().join("\n")}")
end

