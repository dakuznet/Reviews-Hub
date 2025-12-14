json.extract! movie, :id, :title, :director, :screenwriter, :producer, :year, :genre, :description, :url, :duration, :country, :studio, :user_id, :created_at, :updated_at
json.url movie_url(movie, format: :json)
