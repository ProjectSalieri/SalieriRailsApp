
class Admin::TestsController < ApplicationController

  # CSRFトークンエラー対応
  protect_from_forgery with: :null_session

  # igoの動作確認
  def igo_test
    salieri = Salieri.new
    ret = salieri.parse_for_genre_categorize("私はサッカーが好きです")
    render :text => ret
  end

  # pythonの動作確認
  def python_test
    msg = exec_python_script(File.join('nlp', 'sample.py'))
    render :text => msg
  end

  # numpyの動作確認
  def numpy_test
    msg = exec_python_script(File.join('nlp', 'numpy_sample.py'))
    render :text => msg
  end

  # MySQL-pythonの動作確認
  def python_sql_test
    msg = exec_python_script(File.join('nlp', 'mysql_sample.py'))
    render :text => msg
  end

  # GETリクエストの動作確認
  def get_test
    render :text => params
  end

  # POSTリクエストの動作確認
  def post_test
    render :text => params
  end

  private
  def exec_python_script(script_rel_path)
    cmd_array = [
                 "python #{File.join(Rails.root.to_s, 'lib', script_rel_path)}",
                ]

    msg = ""
    cmd_array.each { |cmd|
      msg += "[command]#{cmd}\n<br>"
      ret = `#{cmd}`
      msg += "[output]" + ret.gsub("\n", "<br>") + "\n<br>"
    }
    return msg
  end

end
