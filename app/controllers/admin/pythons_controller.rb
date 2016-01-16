class Admin::PythonsController < ApplicationController

  # CSRFトークンエラー対応
  protect_from_forgery with: :null_session

  # GET /admin/pythons/new_file
  def new_file
    
  end

  # POST /admin/pythons/twitter
  def create_file
    unless params.key?(:file_path)
      render :text => "#{Rails.root.to_s}からのファイルの相対パスを入力してください"
      return false
    end

    file_path = File.join(Rails.root.to_s, params[:file_path])
    content = params[:content]
    unless File.exists?(File.dirname(file_path))
      require 'fileutils'
      FileUtils.mkpath(File.dirname(file_path)) 
    end
    File.open(file_path, "w:utf-8:utf-8"){ |fout| fout.write(content) }

    render :text => "#{file_path}を作成しました"
  end
end
