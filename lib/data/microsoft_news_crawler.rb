#
# @file 
# @author Masakaze Sato
#

require "open-uri"

module MicrsoftNewsFunction
  SERVER_URL = "http://www.msn.com"
  TOP_URL = "#{SERVER_URL}/ja-jp"
  DEFAULT_CATEGORIES = ["entertainment", "techandscience", "money", "sports"]

  def self.get_category_top_url(category) ; return "#{TOP_URL}/news/#{category}" ; end

  # 指定URLのhtml取得
  def self.get_html(url)
    html = ""
    open(url) { |uri| html = uri.read }
    return html
  end

  # カテゴリ指定してURL一覧を取得
  def self.get_url_catalog(category)
    url = self.get_category_top_url(category)
    html = self.get_html(url) 
    
    #regex = "<li class=\"hdlist\".*>.*<a href=\"(.*?)\".*?>.*?<\/a>.*<\/li>"
    regex = "<li.*?>.*?<a href=\"(.*?)\".*?>\r\n[^<.]*?<\/a>.*?<\/li>"
    results = []
    url_array = html.scan(/#{regex}/m)
    url_array.each { |url|
      next if url[0] == "/ja-jp"
      next if /^http:\/\/www\.bing/ =~ url[0]
      url[0] = "#{SERVER_URL}#{url[0]}" if /^\/ja-jp/ =~ url[0]
      results << { :url => url[0] }
    }

    return results
  end

  # 指定urlの記事を取得
  def self.get_news(url)
    result = { :title => "", :content => "" }

    html = self.get_html(url)

    # title
    /<title>(.*?)<\/title>/m =~ html
    result[:title] = $1

    # content
    /<meta\s*name=\"description\"\s*content=\"(.*?)\"/ =~ html
    result[:content] = $1

    return result
  end
end

# テスト関数
if __FILE__ == $0
  url = MicrsoftNewsFunction::TOP_URL
=begin
  open(url) { |uri|
    puts uri.read
  }
=end
  results = MicrsoftNewsFunction.get_url_catalog("money")
  results.each { |result|
    puts MicrsoftNewsFunction.get_news(result[:url])
  }

end
