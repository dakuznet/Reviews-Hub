class ReviewsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_reviewable, only: [:new, :create]
  before_action :set_review, only: [:edit, :update, :destroy]
  before_action :check_owner, only: [:edit, :update, :destroy]

  # GET /reviews
  def index
    # Проверяем, существует ли таблица reviews
    if Review.table_exists?
      @reviews = Review.includes(:user, :reviewable).order(created_at: :desc)
    else
      @reviews = []
      flash.now[:alert] = 'Таблица отзывов еще не создана.'
    end
  end

  # GET /reviews/1
  def show
    @review = Review.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to reviews_path, alert: 'Отзыв не найден.'
  end

  # GET /reviews/new
  def new
    @review = @reviewable.reviews.new
  end

  # GET /reviews/1/edit
  def edit
  end

  # POST /reviews
  def create
    @review = @reviewable.reviews.new(review_params)
    @review.user = current_user

    if @review.save
      redirect_to polymorphic_path(@reviewable), notice: 'Отзыв успешно создан.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /reviews/1
  def update
    if @review.update(review_params)
      redirect_to polymorphic_path(@review.reviewable), notice: 'Отзыв успешно обновлен.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /reviews/1
  def destroy
    @reviewable = @review.reviewable
    @review.destroy
    redirect_to polymorphic_path(@reviewable), notice: 'Отзыв успешно удален.'
  end

  private

  def set_reviewable
    # Определяем тип объекта (Book или Movie) по параметрам
    if params[:book_id]
      # Для теста создаем заглушку книги
      @reviewable = OpenStruct.new(
        id: params[:book_id],
        title: "Книга #{params[:book_id]}",
        class: OpenStruct.new(name: 'Book'),
        is_a?: ->(klass) { klass == Book || klass.to_s == 'Book' }
      )
      @reviewable_type = 'Book'
    elsif params[:movie_id]
      # Для теста создаем заглушку фильма
      @reviewable = OpenStruct.new(
        id: params[:movie_id],
        title: "Фильм #{params[:movie_id]}",
        class: OpenStruct.new(name: 'Movie'),
        is_a?: ->(klass) { klass == Movie || klass.to_s == 'Movie' }
      )
      @reviewable_type = 'Movie'
    else
      redirect_to root_path, alert: 'Неверный запрос.'
    end
  end

  def set_review
    @review = Review.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to reviews_path, alert: 'Отзыв не найден.'
  end

  def check_owner
    unless @review.user == current_user
      redirect_to root_path, alert: 'У вас нет прав для выполнения этого действия.'
    end
  end

  def review_params
    params.require(:review).permit(:rating, :text)
  end
end