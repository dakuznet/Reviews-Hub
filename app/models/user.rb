class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Связи
  has_many :reviews, dependent: :destroy
  has_many :books, dependent: :destroy
  has_many :movies, dependent: :destroy
  
  # Метод для получения всех отзывов пользователя
  def user_reviews
    reviews.order(created_at: :desc)
  end
  
  # Метод для получения всех книг пользователя
  def user_books
    books.order(created_at: :desc)
  end
  
  # Метод для получения всех фильмов пользователя
  def user_movies
    movies.order(created_at: :desc)
  end
end