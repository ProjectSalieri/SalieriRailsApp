class CreateTwitterAccounts < ActiveRecord::Migration
  def change
    create_table :twitter_accounts do |t|
      t.string :name_en
      t.string :consumer_key
      t.string :consumer_secret
      t.string :access_token_key
      t.string :access_token_secret

      t.timestamps null: false
    end
  end
end
