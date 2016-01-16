class SalierisController < ApplicationController

  # CSRFトークンエラー対応
  protect_from_forgery with: :null_session

  def talk_to
    abort if params[:name_en] == nil
    doc = params[:document]

    user = TwitterAccount.find_by({:name_en => params[:name_en]})
    post_ret = user.post("@#{Salieri.twitter_account_name} #{doc}")

    salieri = TwitterAccount.find_by({:name_en => Salieri.twitter_account_name})
    reply_msg = "[Salieri]科学の話題ですよね？(test)\n http://www.msn.com/ja-jp/news/techandscience/%E3%82%BD%E3%83%BC%E3%82%B7%E3%83%A3%E3%83%AB%E3%83%AD%E3%83%9C%E3%83%83%E3%83%88%E3%81%AE%E6%99%82%E4%BB%A3-%E3%82%B7%E3%83%B3%E3%82%AC%E3%83%9D%E3%83%BC%E3%83%AB%E3%81%A7%E3%81%8A%E6%8A%AB%E9%9C%B2%E7%9B%AE%E3%81%95%E3%82%8C%E3%81%9F%E6%9C%80%E5%85%88%E7%AB%AF%E3%81%AE%E4%BA%BA%E5%9E%8B%E3%83%AD%E3%83%9C%E3%83%83%E3%83%88/ar-CCqNzJ"
    salieri.post("@#{post_ret.user.screen_name} #{reply_msg}", {:reply_id => post_ret.id})

    render :text => "success"

    # 正解データがあったらcorpus更新
    if params[:category_type]

    end
  end

  include Data::MicrosoftNewsCrawler

  # 
  def read_news
    # @todo カテゴリや、一覧から選択する部分は好みに合わせて
    news_category = MicrosoftNewsFunction::DEFAULT_CATEGORIES.sample()
    results = MicrosoftNewsFunction.get_url_catalog(news_category)
    url = results.sample[:url]

    news_info = MicrosoftNewsFunction.get_news(url)

    post_msg = "[Salieri]感想機能はまだ。自主的にニュース読むようにしたい\n#{news_info[:title]}\n#{url}"
    salieri = TwitterAccount.find_by({:name_en => Salieri.twitter_account_name})
    salieri.post(post_msg)    

    render :text => post_msg
    
  end

  # 下記コードはテスト用に違うコントローラーにしておくべき

  def sample
    render :text => "success"
  end

  def igo_sample
    salieri = Salieri.new
    ret = salieri.parse_for_genre_categorize("私はサッカーが好きです")
    render :text => ret
  end

  def python_sample
    cmd_array = [
                 "python #{File.join(Rails.root.to_s, 'lib', 'nlp', 'sample.py')}",
                ]
    msg = ""
    cmd_array.each { |cmd|
      msg += "[command]#{cmd}\n<br>"
      msg += "[output]" + `#{cmd}` + "\n<br>"
    }
    render :text => msg
  end

  def get_sample
    render :text => params
  end

  def post_sample
    render :text => params
  end
end
