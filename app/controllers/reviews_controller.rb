class ReviewsController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]
  before_action :set_reviewable, only: [ :create, :new ]
  before_action :set_review, only: [ :edit, :update, :destroy, :show ]
  before_action :authorize_user, only: [ :edit, :update, :destroy ]

  def index
    @reviews = Review.all.order(created_at: :desc)
  end

  def show
  end

  def new
    @review = @reviewable.reviews.new
  end

  def create
    @review = @reviewable.reviews.new(review_params)
    @review.user = current_user

    if @review.save
      redirect_to @reviewable, notice: "Отзыв успешно добавлен."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @review.update(review_params)
      redirect_to @reviewable || root_path, notice: "Отзыв обновлен."
    else
      render :edit
    end
  end

  def destroy
    @review.destroy
    redirect_to @reviewable || root_path, notice: "Отзыв удален."
  end

  private

  def set_reviewable
    if params[:book_id]
      @reviewable = Book.find_by(id: params[:book_id])
    elsif params[:movie_id]
      @reviewable = Movie.find_by(id: params[:movie_id])
    end
    redirect_to root_path, alert: "Произведение не найдено." unless @reviewable
  end

  def set_review
    @review = Review.find(params[:id])
    @reviewable = @review.reviewable
  end

  def authorize_user
    unless @review.user == current_user
      redirect_to @reviewable || root_path, alert: "У вас нет прав на это действие."
    end
  end

  def review_params
    params.require(:review).permit(:rating, :text)
  end
end
