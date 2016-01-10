class SalierisController < ApplicationController

  def sample
    salieri = Salieri.new
    ret = salieri.parse_for_genre_categorize("私はサッカーが好きです")
    render :text => ret
  end

  def python_sample
    cmd = "python #{File.join(Rails.root.to_s, 'lib', 'nlp', 'sample.py')}"
    ret = `#{cmd}`
    render :text => ret
  end
end
