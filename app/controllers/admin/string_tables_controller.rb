class Admin::StringTablesController < ApplicationController

  # CSRFトークンエラー対応
  protect_from_forgery with: :null_session

  def index
    @strings = Admin::StringTable.all
  end
end
