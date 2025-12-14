class ReviewsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  
  # GET /books/:book_id/reviews/new
  # GET /movies/:movie_id/reviews/new
  def new
    # Определяем, к какой модели относится отзыв
    if params[:book_id]
      @reviewable = Book.find(params[:book_id])
    elsif params[:movie_id]
      @reviewable = Movie.find(params[:movie_id])
    else
      redirect_to root_path, alert: "Не указана модель для отзыва"
      return
    end
    
    @review = @reviewable.reviews.new
  end
  
  # POST /books/:book_id/reviews
  # POST /movies/:movie_id/reviews
  def create
    if params[:book_id]
      @reviewable = Book.find(params[:book_id])
    elsif params[:movie_id]
      @reviewable = Movie.find(params[:movie_id])
    else
      redirect_to root_path, alert: "Не указана модель для отзыва"
      return
    end
    
    @review = @reviewable.reviews.new(review_params)
    @review.user = current_user
    
    if @review.save
      redirect_to @reviewable, notice: "Отзыв успешно добавлен!"
    else
      render :new
    end
  end
  
  # GET /reviews
  def index
    @reviews = Review.includes(:user, :reviewable)
                     .order(created_at: :desc)
                     .page(params[:page])
  end
  
  # GET /reviews/:id
  def show
    @review = Review.includes(:user, :reviewable).find(params[:id])
  end
  
  # GET /books/:book_id/reviews/:id/edit
  # GET /movies/:movie_id/reviews/:id/edit
  def edit
    @review = Review.find(params[:id])
    
    # Проверяем, что пользователь - автор отзыва
    if @review.user != current_user
      redirect_to @review.reviewable, alert: "Вы не можете редактировать чужой отзыв"
      return
    end
    
    # Определяем reviewable объект
    @reviewable = @review.reviewable
  end
  
  # PATCH /books/:book_id/reviews/:id
  # PATCH /movies/:movie_id/reviews/:id
  def update
    @review = Review.find(params[:id])
    
    # Проверяем, что пользователь - автор отзыва
    if @review.user != current_user
      redirect_to @review.reviewable, alert: "Вы не можете редактировать чужой отзыв"
      return
    end
    
    if @review.update(review_params)
      redirect_to @review.reviewable, notice: "Отзыв успешно обновлен!"
    else
      @reviewable = @review.reviewable
      render :edit
    end
  end
  
  # DELETE /books/:book_id/reviews/:id
  # DELETE /movies/:movie_id/reviews/:id
  def destroy
    @review = Review.find(params[:id])
    
    # Проверяем, что пользователь - автор отзыва
    if @review.user != current_user
      redirect_to @review.reviewable, alert: "Вы не можете удалить чужой отзыв"
      return
    end
    
    @reviewable = @review.reviewable
    @review.destroy
    
    redirect_to @reviewable, notice: "Отзыв успешно удален!"
  end
  
  private
  
  def review_params
    params.require(:review).permit(:rating, :text)
  end
end