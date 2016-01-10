class CreateDocCategoryInfos < ActiveRecord::Migration
  def change
    create_table :doc_category_infos do |t|
      t.integer :doc_category_id
      t.integer :word_id
      t.integer :appear_count # @todo bigintにすべきかも

      t.timestamps null: false
    end

    add_foreign_key :doc_category_infos, :doc_categories, column: :doc_category_id
    add_foreign_key :doc_category_infos, :words, column: :word_id
  end
end
