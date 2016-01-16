class Admin::PythonsController < ApplicationController

  # CSRFトークンエラー対応
  protect_from_forgery with: :null_session

  def env_check
    render :text => ENV[params[:key]]
  end

end
