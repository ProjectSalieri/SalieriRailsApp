class Salieri::TwittersController < ApplicationController

  # CSRFトークンエラー対応
  protect_from_forgery with: :null_session

  # GET ツイート投稿準備
  def new_tweet

  end

  # POST ツイート投稿
  def create_tweet
    # @todo ユーザー指定
    user = TwitterAccount.find_by({:name_en => "SalieriNeighbor"})
    abort(paramsにmessageを設定してください) unless params.key?(:message)

    msg = params[:message]
    user.post(msg)

    render :text => "success"
    
  end

end
