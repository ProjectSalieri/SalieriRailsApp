class Admin::PythonsController < ApplicationController

  # CSRFトークンエラー対応
  protect_from_forgery with: :null_session
end
