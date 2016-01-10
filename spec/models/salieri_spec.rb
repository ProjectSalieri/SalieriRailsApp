require 'spec_helper'

describe Salieri do
  it 'parse_for_genre_categorize' do
    document = "私はサッカーが好きです"

    salieri = Salieri.new()
    ret = salieri.parse_for_genre_categorize(document)

    expect(ret).to eq ["サッカー", "好き"]
  end
end
