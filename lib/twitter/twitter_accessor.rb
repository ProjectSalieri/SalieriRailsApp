# -*- coding: utf-8 -*-
# @file 	TwitterAccessor.rb
# @author 	Masakaze Sato
# 
# @brief 	Twitterへのアクセサ

require 'rubygems'
require 'twitter'
require 'yaml'

include Twitter

ENV["SSL_CERT_FILE"] = "#{File.dirname(__FILE__)}/cacert.pem"

#
# Tweet情報
#
class TweetInfo

  attr_accessor :text, :screen_name, :name, :id

  def initialize()
    @text = nil
    @screen_name = nil
    @name = nil
    @id = nil
  end

  #
  # Twitter::Tweetクラスから情報作成
  #
  def create_from_tweet_class(tweet)
    @text = tweet.text
    @screen_name = tweet.user.screen_name
    @name = tweet.user.name
    @id = tweet.id
  end

  #
  # search関数の返り値から(Hash)
  #
  def create_from_search_result(tweet)
    @text = tweet[:text]
    @screen_name = tweet[:user][:screen_name]
    @name = tweet[:user][:name]
  end

end

#
# Twitterのアクセサ
#
class TwitterAccessor

  def initialize()
    @client = nil
  end

#
# 初期化
#

  #
  # ログイン
  #
  def login(consumer_key, consumer_secret, oauth_token, oauth_token_secret)
    @client = Twitter::REST::Client.new { |config|
      config.consumer_key = consumer_key
      config.consumer_secret = consumer_secret
      config.access_token = oauth_token
      config.access_token_secret = oauth_token_secret
    }
  end

  #
  # ログイン
  #
  def login_from_file(user_log_info_yaml)
    user_log_info = YAML.load_documents(File.open(user_log_info_yaml).read())[0]
    login(user_log_info["ConsumerKey"],
          user_log_info["ConsumerKeySecret"],
          user_log_info["AccessToken"],
          user_log_info["AccessTokenSecret"])
  end

#
#
#
  def get_client()
    if @client == nil
      puts "TwitterAccessor::Loginを実行してください"
      exit 1
    end

    return @client
  end

end

if __FILE__ == $0
  accessor = TwitterAccessor.new()

  accessor.login_from_file("Test.yaml")
end
