Rails.application.routes.draw do
  # Главная страница
  root "pages#home"

  # Маршруты для аутентификации
  devise_for :users

  # Ресурсные маршруты для книг
  resources :books do
    resources :reviews, only: [:new, :create, :destroy, :edit, :update]  # Добавляем :new
  end

  # Ресурсные маршруты для фильмов
  resources :movies do
    resources :reviews, only: [:new, :create, :destroy, :edit, :update]  # Добавляем :new
  end

  # Отдельные маршруты для отзывов
  resources :reviews, only: [:index, :show]

  # Профиль пользователя
  get 'profile', to: 'users#show', as: :user_profile
  get 'profile/reviews', to: 'users#reviews', as: :user_reviews
  get 'profile/books', to: 'users#books', as: :user_books
  get 'profile/movies', to: 'users#movies', as: :user_movies
end