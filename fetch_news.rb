require 'nokogiri'
require 'open-uri'

url = 'https://lite.cnn.com/'
html = URI.open(url).read
doc = Nokogiri::HTML(html)
first_link = doc.at_css('li a')['href']
article_url = "https://lite.cnn.com#{first_link}"
article_html = URI.open(article_url).read
article_doc = Nokogiri::HTML(article_html)
body_text = article_doc.css('p').map(&:text).join("\n\n")
puts body_text
