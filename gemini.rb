require 'dotenv/load'
require 'net/http'
require 'uri'
require 'json'

def text_to_json(text)
  api_key = ENV['GEMINI_API_KEY']
  if api_key.nil? || api_key.strip.empty?
    puts "❌ APIキーが読み込めていません。"
    return nil
  end

  url = URI("https://generativelanguage.googleapis.com/v1beta/models/gemini-3.8-flash:generateContent?key=#{api_key}")
  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true
  
  http.read_timeout = 60

  prompt = <<~PROMPT
    あなたはIELTS 6.0を目指す学習者向けのチューターです。提供されたニュースを読み、以下のキーを持つJSONのみを出力してください。
    - headline: 短い英語見出し
    - semantic_question: なぜこのニュースが重要かを問う日本語の質問1文
    - ielts_summary: 事実を伝える3行の英文
    - japanese_context: ニュースの背景の日本語解説
    - vocab_list: [{"word": "英単語", "meaning": "日本語訳"}] を3つ
  PROMPT

  request = Net::HTTP::Post.new(url)
  request["Content-Type"] = "application/json"
  
  request.body = {
    "contents" => [
      {
        "parts" => [
          { "text" => "#{prompt}\n\n【本文】\n#{text[0..1500]}" }
        ]
      }
    ],
    "generationConfig" => {
      "responseMimeType" => "application/json"
    }
  }.to_json

  response = http.request(request)

  if response.is_a?(Net::HTTPSuccess)
    result_text = JSON.parse(response.body).dig("candidates", 0, "content", "parts", 0, "text")
    JSON.parse(result_text)
  else
    puts "❌ API通信エラー: #{response.code} #{response.message}"
    puts response.body
    nil
  end
rescue => e
  puts "❌ 例外発生: #{e.message}"
  nil
end
