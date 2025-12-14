Rails.application.routes.draw do
  # Главная страница
  root "pages#home"

  # Статические страницы
  get "books", to: "pages#books"
  get "movies", to: "pages#movies"

  # Маршруты для аутентификации пользователей
  devise_for :users

  # Временные маршруты для просмотра книг и фильмов
  # (будут заменены полноценными контроллерами на следующем этапе)
  get '/books/:id', to: 'pages#book_show', as: 'book'
  get '/movies/:id', to: 'pages#movie_show', as: 'movie'

  # Вложенные маршруты для отзывов:
  # /books/1/reviews/new - новый отзыв на книгу
  # /movies/1/reviews/1/edit - редактирование отзыва на фильм
  resources :books, only: [:show] do
    resources :reviews, only: [:new, :create, :edit, :update, :destroy]
  end

  resources :movies, only: [:show] do
    resources :reviews, only: [:new, :create, :edit, :update, :destroy]
  end

  # Отдельные маршруты для просмотра всех отзывов
  resources :reviews, only: [:index, :show]
end