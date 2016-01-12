json.array!(@twitter_accounts) do |twitter_account|
  json.extract! twitter_account, :id, :name_en, :consumer_key, :consumer_secret, :access_token_key, :access_token_secret
  json.url twitter_account_url(twitter_account, format: :json)
end
