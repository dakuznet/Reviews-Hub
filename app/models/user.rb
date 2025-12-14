class User < ApplicationRecord
  # Модули Devise для аутентификации
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Связь с отзывами - один пользователь может оставить много отзывов
  has_many :reviews, dependent: :destroy

  # Метод для получения отзывов пользователя, отсортированных по дате
  def user_reviews
    reviews.order(created_at: :desc)
  end
end