class UsersController < ApplicationController
  before_action :authenticate_user!
  
  def show
    @user = current_user
    @reviews = @user.reviews.includes(:reviewable).order(created_at: :desc).limit(5)
    @books = @user.books.order(created_at: :desc).limit(5)
    @movies = @user.movies.order(created_at: :desc).limit(5)
  end
  
  def reviews
    @user = current_user
    @reviews = @user.reviews.includes(:reviewable).order(created_at: :desc).page(params[:page])
  end       
  
  def movies
    @user = current_user
    @movies = @user.movies.order(created_at: :desc).page(params[:page])
  end
end