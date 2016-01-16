class CreateAdminStringTables < ActiveRecord::Migration
  def change
    create_table :admin_string_tables do |t|
      t.string :key
      t.string :value

      t.timestamps null: false
    end
  end
end
