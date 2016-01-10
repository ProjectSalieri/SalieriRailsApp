# -*- coding: utf-8 -*-
# @file 	TwitterUtil.rb
# @author 	Masakaze Sato
# 
# @brief 	Twitterのユーティリティ

require 'rubygems'
require 'twitter'

require_relative 'twitter_accessor'

TWITTER_TO_REX = "(^@[\\dA-Za-z_\\s\\@]*)\\s"
TWITTER_URL_REX = "http:\\/\\/[\\dA-Za-z_\\/\\.]*"

module Twitter
module TwitterUtil

#
# ユーザー情報取得
#
  #
  # 
  #
  def get_user(accessor)
    client = accessor.get_client()
    return accessor.get_client().user
  end

  #
  # フレンド数
  #
  def get_friends_count(accessor)
    return get_user(accessor).friends_count
  end

  #
  # フォローワー数取得
  #
  def get_followers_count(accessor)
    return get_user(accessor).followers_count
  end

  #
  # ツイート数
  #
  def get_tweets_count(accessor)
    return get_user(accessor).tweets_count
  end

  #
  # ホームタイムライン取得
  #
  def get_home_timelines(accessor)
    result = accessor.get_client().home_timeline()
    tweets = Array.new()
    result.each { |tweet|
      info = TweetInfo.new()
      info.create_from_tweet_class(tweet)
      tweets << info
    }
    return tweets
  end

  #
  # 投稿
  #
  def post(accessor, text, post_options = {})
    accessor.get_client().update(text, post_options)
  end
  module_function :post

  #
  #
  #
  def get_user_timelines(accessor, user_name)
    return accessor.get_client().user_timeline(user_name)
  end

  #
  # 検索
  #
  def search_tweets_from_keyword(accessor, keyword)
    result = accessor.get_client().search(keyword, :result_type => "recent", :count => 20).to_h[:statuses]
    tweets = Array.new()
    result.each { |tweet|
      info = TweetInfo.new()
      info.create_from_search_result(tweet)
      tweets << info
    }
    return tweets
  end

#
# TweetInfoから特定の情報を抽出
#
  #
  # 宛先をユーザー名を取得
  #
  def get_to_user(info)
    text = info.text
    /#{TWITTER_TO_REX}.*/ =~ text
    to_array = $1.split(/\s+/).select { |to| to.slice!(0) }
    return to_array
  end

  #
  # URLを抽出
  #
  def extract_url(info)
    text = info.text
    url_array = text.scan(/#{TWITTER_URL_REX}/)
    return url_array
  end

end
end

if __FILE__ == $0

  include TwitterUtil

  accessor = TwitterAccessor.new()
  accessor.login_from_file("Test.yaml")

  home_timelines = get_home_timelines(accessor)
  home_timelines.each { |home_timeline|
    puts "-----------------------------------------------------"
    puts "ScreenName:#{home_timeline.screen_name}"
    puts "Name:#{home_timeline.name}"
    puts home_timeline.text
  }

  search_tweets_from_keyword(accessor, "サッカー").each { |tweet|
    puts "-----------------------------------------------------"
    puts "ScreenName:#{tweet.screen_name}"
    puts "Name:#{tweet.name}"
    puts tweet.text
  }

end
