require 'sqlite3'
require 'json'

def setup_db
  db = SQLite3::Database.new("news_learning.db")
  
  db.execute(<<~SQL)
    CREATE TABLE IF NOT EXISTS articles (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      url TEXT UNIQUE,
      headline TEXT,
      semantic_question TEXT,
      ielts_summary TEXT,
      japanese_context TEXT,
      vocab_list TEXT,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP
    );
  SQL
  db
end
def article_exists?(url)
  db = setup_db
  result = db.execute("SELECT 1 FROM articles WHERE url = ?", [url])
  !result.empty?
end
def save_to_db(url, data)
  db = setup_db
  db.execute(
    "INSERT INTO articles (url, headline, semantic_question, ielts_summary, japanese_context, vocab_list) VALUES (?, ?, ?, ?, ?, ?)",
    [
      url, 
      data['headline'], 
      data['semantic_question'], 
      data['ielts_summary'], 
      data['japanese_context'], 
      data['vocab_list'].to_json # 配列はJSON文字列にして保存
    ]
  )
  puts "💾 DBに保存しました！（news_learning.db）"
end
