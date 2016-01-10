class CreateDocCategoryTypes < ActiveRecord::Migration
  def change
    create_table :doc_category_types do |t|
      t.string :name_jp
      t.string :name_en

      t.timestamps null: false
    end
  end
end
