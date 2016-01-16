class Admin::PythonsController < ApplicationController

  # CSRFトークンエラー対応
  protect_from_forgery with: :null_session

  # GET
  def index_file
    @files = Admin::StringTable.where(:key => Admin::StringTable.key_file)
  end

  # GET /admin/pythons/new_file
  def new_file
    @file_path = ""
    @content = ""
  end

  # POST /admin/pythons/twitter
  def create_file
    unless params.key?(:file_path)
      render :text => "#{Rails.root.to_s}からのファイルの相対パスを入力してください"
      return false
    end

    params_proc_for_file(params)
    @file_path = File.join(Rails.root.to_s, params[:file_path])

    output_file(@file_path, @content)

    render :text => "#{file_path}を作成しました"
  end

  # GET
  def edit_file
    params_proc_for_file(params)
  end

  # PUT
  def update_file
    params_proc_for_file(params)

    output_file(@file_path, @content)

    respond_to do |format|
      format.html { redirect_to index_file_admin_pythons_path }
    end
  end
  
  # DELETE
  def delete_file
    params_proc_for_file(params)
    if File.exist?(@file_path)
      require 'fileutils'
      FileUtils.rm(@file_path)
    end

    @file.destroy

    respond_to do |format|
      format.html { redirect_to index_file_admin_pythons_path, :notice => "#{@file_path}を削除しました" }
    end
  end

  private
  def params_proc_for_file(params)
    @file = Admin::StringTable.find(params[:id])
    @file_path = @file.value

    if params.key?(:content)
      @content = params[:content]
    elsif File.exist?(@file_path)
      File.open(@file_path, "r") { |fin| @content = fin.read() }
    else
      @content = ""
    end
  end

  def output_file(file_path, content)
    unless File.exists?(File.dirname(file_path))
      require 'fileutils'
      FileUtils.mkpath(File.dirname(file_path)) 
    end
    File.open(file_path, "w:utf-8:utf-8"){ |fout| fout.write(content) }

    info = Admin::StringTable.find_or_create_by({:key => Admin::StringTable.key_file, :value => file_path})
  end

end
