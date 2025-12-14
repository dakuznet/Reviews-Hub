class Review < ApplicationRecord
  # Связи с другими моделями
  belongs_to :user
  belongs_to :reviewable, polymorphic: true  # Может принадлежать как Book, так и Movie

  # Валидации
  validates :rating, presence: true, 
                     inclusion: { in: 1..5, message: "Рейтинг должен быть от 1 до 5" }
  validates :text, presence: true, 
                   length: { minimum: 10, message: "Текст отзыва должен содержать минимум 10 символов" }
  validates :user_id, uniqueness: { 
    scope: [:reviewable_type, :reviewable_id], 
    message: "Вы уже оставили отзыв на это произведение" 
  }

  # Метод для проверки, принадлежит ли отзыв пользователю
  def belongs_to_user?(user)
    self.user == user
  end
end