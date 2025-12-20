class Book < ApplicationRecord
  belongs_to :user
  has_many :reviews, as: :reviewable, dependent: :destroy

  validates :title, presence: { message: "Название обязательно для заполнения" }
  validates :author, presence: { message: "Автор обязателен для заполнения" }
  validates :year, numericality: {
    only_integer: true,
    greater_than: 0,
    less_than_or_equal_to: Date.today.year,
    message: "Год должен быть действительным числом"
  }, allow_nil: true
  validates :edition, length: { maximum: 100, message: "Издание не должно превышать 100 символов" }
  validates :genre, length: { maximum: 50, message: "Жанр не должен превышать 50 символов" }
  validates :description, length: { maximum: 2000, message: "Описание не должно превышать 2000 символов" }
  validates :url, format: {
    with: URI::DEFAULT_PARSER.make_regexp(%w[http https]),
    message: "URL должен быть действительным адресом",
    allow_blank: true
  }

  def average_rating
    reviews.average(:rating)&.round(1) || 0
  end

  def reviews_count
    reviews.count
  end

  def self.search(query)
    if query.present?
      where("title ILIKE ? OR author ILIKE ? OR genre ILIKE ?",
            "%#{query}%", "%#{query}%", "%#{query}%")
    else
      all
    end
  end
end
