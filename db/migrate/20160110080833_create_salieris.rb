class CreateSalieris < ActiveRecord::Migration
  def change
    create_table :salieris do |t|

      t.timestamps null: false
    end
  end
end
