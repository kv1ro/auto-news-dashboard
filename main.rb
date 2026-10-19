require_relative 'fetch_news'
require_relative 'gemini'
require 'json'

links = get_article_links

links.each_with_index do |url, index|
  puts "📄 [#{index + 1}/#{links.length}]#{url}"
  text = get_article_text(url)
  if text && !text.empty?
    json_data = text_to_json(text)
    if json_data
      puts JSON.pretty_generate(json_data)
    end
  else
    puts "skip"
    sleep 5
  end
end
