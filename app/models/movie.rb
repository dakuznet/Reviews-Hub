class Movie < ApplicationRecord
  belongs_to :user
  has_many :reviews, as: :reviewable, dependent: :destroy
  
  validates :title, presence: { message: "Название обязательно для заполнения" }
  validates :director, presence: { message: "Режиссер обязателен для заполнения" }
  validates :year, numericality: { 
    only_integer: true, 
    greater_than: 0, 
    less_than_or_equal_to: Date.today.year,
    message: "Год должен быть действительным числом" 
  }
  validates :genre, length: { maximum: 50, message: "Жанр не должен превышать 50 символов" }
  validates :description, length: { maximum: 2000, message: "Описание не должно превышать 2000 символов" }
  validates :duration, numericality: { 
    only_integer: true, 
    greater_than: 0, 
    message: "Длительность должна быть положительным числом",
    allow_nil: true 
  }
  validates :country, length: { maximum: 100, message: "Страна не должна превышать 100 символов" }
  validates :studio, length: { maximum: 100, message: "Студия не должна превышать 100 символов" }
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
      where("title ILIKE ? OR director ILIKE ? OR genre ILIKE ? OR screenwriter ILIKE ?", 
            "%#{query}%", "%#{query}%", "%#{query}%", "%#{query}%")
    else
      all
    end
  end
  
  def formatted_duration
    return "Не указана" unless duration
    hours = duration / 60
    minutes = duration % 60
    "#{hours} ч #{minutes} мин"
  end
end