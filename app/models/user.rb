class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :reviews, dependent: :destroy
  has_many :movies, dependent: :destroy
  
  def user_reviews
    reviews.order(created_at: :desc)
  end
  
  def user_movies
    movies.order(created_at: :desc)
  end
end