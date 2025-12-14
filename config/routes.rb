Rails.application.routes.draw do
  # Главная страница
  root "pages#home"

  # Маршруты для аутентификации
  devise_for :users

  # Ресурсные маршруты для книг и фильмов
  resources :books do
    resources :reviews, only: [:create, :destroy, :edit, :update]
    
    # Коллекция для поиска
    collection do
      get :search
    end
  end

  resources :movies do
    resources :reviews, only: [:create, :destroy, :edit, :update]
    
    # Коллекция для поиска
    collection do
      get :search
    end
  end

  # Отдельные маршруты для отзывов
  resources :reviews, only: [:index, :show]

  # Профиль пользователя
  get 'profile', to: 'users#show', as: :user_profile
  get 'profile/reviews', to: 'users#reviews', as: :user_reviews
  get 'profile/books', to: 'users#books', as: :user_books
  get 'profile/movies', to: 'users#movies', as: :user_movies
end