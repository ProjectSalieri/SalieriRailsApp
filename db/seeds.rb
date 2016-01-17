# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

def exit_with_trace(msg, e)
  abort("#{msg}\n#{e.message.to_s}\n#{e.backtrace.join("\n")}")
end

# DocCategoryType
begin
  category_type_info_array = [
                              {:name_jp => "ジャンル", 	:name_en => "Genre"},
                              {:name_jp => "感情", 		:name_en => "Emotion"}
                             ]
  category_type_info_array.each { |category_type_info|
    category_type = DocCategoryType.find_or_create_by(category_type_info)
  }
rescue => e
  exit_with_trace("DocCategoryTypeのseedsに失敗", e)
end

# DocCategory
begin
  category_infos = {
    "Genre" => [],
    "Emotion" => []
  }

  # Genreの初期化
  category_type = DocCategoryType.type_genre
  Data::MicrosoftNewsCrawler::DEFAULT_CATEGORIES.each { |category| 
    category_infos["Genre"] << { :name_en => category[:name_en], :name_jp => category[:name_jp], :doc_category_type_id => category_type.id } 
  }
  category_type = DocCategoryType.type_emotion
  emotion_arr = [ 
                 {:name_en => "Happy", :name_jp => "嬉しい"},
                 {:name_en => "Anger", :name_jp => "怒り"},
                 {:name_en => "Sad", :name_jp => "悲しい"},
                 {:name_en => "Joy", :name_jp => "楽しい"},
                ]
  emotion_arr.each { |emotion|
    category_infos["Emotion"] << { :name_en => emotion[:name_en], :name_jp => emotion[:name_jp], :doc_category_type_id => category_type.id }
  }
  category_infos.each { |type_name_en, category_info_arr|
    category_info_arr.each { |category_info|
      category = DocCategory.find_or_create_by(category_info)
      # 新規カテゴリなら出現頻度の初期化
      if category.appear_count == nil
        category.appear_count = 0
        category.save
      end
    }
  }
rescue => e
  exit_with_trace("DocCategoryのseedsに失敗", e)
end
