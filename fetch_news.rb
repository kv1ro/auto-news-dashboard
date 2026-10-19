require 'nokogiri'
require 'open-uri'

def get_article_links
  url = 'https://lite.cnn.com/'
  html = URI.open(url).read
  doc = Nokogiri::HTML(html)
  
  links = []
  
  doc.css('li').each do |list_item|
    a_tag = list_item.at_css('a')
    
    if a_tag && a_tag['href']
      links << "https://lite.cnn.com#{a_tag['href']}"
    end
  end
  
  links
end

def get_article_text(article_url)
  html = URI.open(article_url).read
  doc = Nokogiri::HTML(html)
  
  doc.css('p').map(&:text).join("\n\n")
rescue => e
  puts "❌ 取得エラー (#{article_url}): #{e.message}"
  nil
end
