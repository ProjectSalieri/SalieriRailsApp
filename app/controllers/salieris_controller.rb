class SalierisController < ApplicationController

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
