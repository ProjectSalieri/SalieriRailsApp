class SalierisController < ApplicationController

  # CSRFトークンエラー対応
  protect_from_forgery with: :null_session

  def talk_to
    abort if params[:name_en] == nil
    msg = params[:message]

    user = TwitterAccount.find_by({:name_en => params[:name_en]})
    post_ret = user.post("@#{Salieri.twitter_account_name} #{msg}")

    salieri = TwitterAccount.find_by({:name_en => Salieri.twitter_account_name})
    reply_msg = "[Salieri]科学の話題ですよね？(test)\n http://www.msn.com/ja-jp/news/techandscience/%E3%82%BD%E3%83%BC%E3%82%B7%E3%83%A3%E3%83%AB%E3%83%AD%E3%83%9C%E3%83%83%E3%83%88%E3%81%AE%E6%99%82%E4%BB%A3-%E3%82%B7%E3%83%B3%E3%82%AC%E3%83%9D%E3%83%BC%E3%83%AB%E3%81%A7%E3%81%8A%E6%8A%AB%E9%9C%B2%E7%9B%AE%E3%81%95%E3%82%8C%E3%81%9F%E6%9C%80%E5%85%88%E7%AB%AF%E3%81%AE%E4%BA%BA%E5%9E%8B%E3%83%AD%E3%83%9C%E3%83%83%E3%83%88/ar-CCqNzJ"
    salieri.post("@#{post_ret.user.screen_name} #{reply_msg}", {:reply_id => post_ret.id})

    render :text => "success"

    # 正解データがあったらcorpus更新
    if params[:category_type]

    end
  end

  # ニュースを読む
  def read_news
    salieri = Salieri.new()
    post_msg = salieri.read_news()

    render :text => post_msg
  end

  def predict_category_test
    salieri = Salieri.new()
    doc = "科学技術の話をしてみる。機械とかITとかそんなのが引っかかる?"
    
    render :text => salieri.predict_category(doc, DocCategoryType.type_genre.name_en)
  end

  # コーパス再整理
  def corpus_arrange
    salieri = Salieri.new()
    salieri.corpus_arrange

    render :text => "success"
  end
end
