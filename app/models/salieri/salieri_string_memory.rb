class Salieri::SalieriStringMemory < ActiveRecord::Base
  self.table_name = 'salieri_salieri_string_memories'

  scope :where_read_news, -> { where(:key => "ReadNews") }
  scope :where_read_tweet, -> { where(:key => "ReadTweet") }

  def self.mark_read(url)
    find_or_create_by({:key => "ReadNews", :value => url})
  end

  def self.is_already_read(url)
    return self.where_read_news.where(:value => url).blank? == false
  end

  def self.mark_read_tweet(tweet_id)
    find_or_create_by({:key => "ReadTweet", :value => tweet_id})
  end

  def self.is_already_read_tweet(tweet_id)
    return self.where_read_tweet.where(:value => tweet_id).blank? == false
  end

end
