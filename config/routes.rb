Rails.application.routes.draw do
  root "pages#home"

  devise_for :users

  resources :movies do
    resources :reviews, only: [:create, :destroy, :edit, :update]
    
    collection do
      get :search
    end
  end

  resources :reviews, only: [:index, :show]

  get 'profile', to: 'users#show', as: :user_profile
  get 'profile/reviews', to: 'users#reviews', as: :user_reviews
  get 'profile/books', to: 'users#books', as: :user_books
  get 'profile/movies', to: 'users#movies', as: :user_movies
end