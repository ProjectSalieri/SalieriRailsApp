class CreateSalieriSalieriStringMemories < ActiveRecord::Migration
  def change
    create_table :salieri_salieri_string_memories do |t|
      t.string :key
      t.text :value

      t.timestamps null: false
    end
  end
end
