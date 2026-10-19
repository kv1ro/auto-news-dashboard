require_relative 'fetch_news'
require_relative 'gemini'
require_relative 'db'
require 'json'

setup_db

puts "Fetching URL list from CNN Lite..."
links = get_article_links
puts "Found #{links.length} article URLs.\n"

links.each_with_index do |url, index|
  puts "--------------------------------------------------"
  puts "[#{index + 1}/#{links.length}] Checking: #{url}"
  
  if article_exists?(url)
    puts "Skipping: Already saved in DB."
    next
  end
  
  text = get_article_text(url)
  
  if text && !text.empty?
    puts "Converting to JSON via Gemini..."
    json_data = text_to_json(text)

    if json_data
      save_to_db(url, json_data)
    end
  else
    puts "Skipping: Failed to fetch article text."
  end
  
  puts "Waiting 5 seconds before the next article..."
  sleep 5
end

puts "\nAll articles processed successfully!"
