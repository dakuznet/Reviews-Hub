class PagesController < ApplicationController
  def home
    @latest_books = Book.includes(:reviews).order(created_at: :desc).limit(3)
    @latest_movies = Movie.includes(:reviews).order(created_at: :desc).limit(3)
    @latest_reviews = Review.includes(:user, :reviewable).order(created_at: :desc).limit(5)
  end
end
