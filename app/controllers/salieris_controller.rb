class SalierisController < ApplicationController

  def sample
    salieri = Salieri.new
    ret = salieri.parse_for_genre_categorize("私はサッカーが好きです")
    render :text => ret
  end
end
