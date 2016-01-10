class AddCategoryTypeIdToWord < ActiveRecord::Migration
  def change
    add_column :words, :doc_category_type_id, :integer
    add_foreign_key :words, :doc_category_types, column: :doc_category_type_id
  end
end
