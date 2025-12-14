json.extract! book, :id, :title, :author, :publisher, :year, :edition, :genre, :description, :url, :user_id, :created_at, :updated_at
json.url book_url(book, format: :json)
