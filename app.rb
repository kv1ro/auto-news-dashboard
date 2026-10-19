require 'sinatra'
require 'erb'
require 'sqlite3'
require 'json'

set :bind, '0.0.0.0'
set :server, 'puma'

get '/' do
  db = SQLite3::Database.new("news_learning.db")
  db.results_as_hash = true
  
  @articles = db.execute("SELECT * FROM articles ORDER BY created_at DESC LIMIT 30")
  
  erb :index
end
