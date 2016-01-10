class CreateDocCategories < ActiveRecord::Migration
  def change
    create_table :doc_categories do |t|
      t.string :name_jp
      t.string :name_en
      t.integer :appear_count
      t.integer :doc_category_type_id

      t.timestamps null: false
    end

    add_foreign_key :doc_categories, :doc_category_types, column: :doc_category_type_id
  end
end
