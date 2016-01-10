class AddCategoryTypeIdToWord < ActiveRecord::Migration
  def change
    add_column :words, :category_type_id, :integer
    add_foreign_key :words, :category_types, column: :category_type_id
  end
end
