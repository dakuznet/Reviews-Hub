class ReviewsController < ApplicationController
  # Действия до выполнения методов
  before_action :authenticate_user!, except: [:index, :show]  # Требуем аутентификации для всех действий, кроме просмотра
  before_action :set_reviewable, only: [:new, :create]        # Находим объект (книгу или фильм) для отзыва
  before_action :set_review, only: [:edit, :update, :destroy] # Находим отзыв
  before_action :check_owner, only: [:edit, :update, :destroy] # Проверяем, принадлежит ли отзыв пользователю

  # Показать все отзывы
  def index
    @reviews = Review.includes(:user, :reviewable).order(created_at: :desc)
  end

  # Показать конкретный отзыв
  def show
    @review = Review.find(params[:id])
  end

  # Форма для создания нового отзыва
  def new
    @review = @reviewable.reviews.new
  end

  # Форма для редактирования отзыва
  def edit
  end

  # Создать новый отзыв
  def create
    @review = @reviewable.reviews.new(review_params)
    @review.user = current_user  # Привязываем отзыв к текущему пользователю

    if @review.save
      redirect_to polymorphic_path(@reviewable), notice: 'Отзыв успешно создан.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # Обновить существующий отзыв
  def update
    if @review.update(review_params)
      redirect_to polymorphic_path(@review.reviewable), notice: 'Отзыв успешно обновлен.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # Удалить отзыв
  def destroy
    @reviewable = @review.reviewable  # Сохраняем объект для редиректа
    @review.destroy
    redirect_to polymorphic_path(@reviewable), notice: 'Отзыв успешно удален.'
  end

  private

  # Находим объект (книгу или фильм), к которому относится отзыв
  def set_reviewable
    if params[:book_id]
      @reviewable = Book.find(params[:book_id])
    elsif params[:movie_id]
      @reviewable = Movie.find(params[:movie_id])
    else
      redirect_to root_path, alert: 'Неверный запрос.'
    end
  end

  # Находим отзыв по ID
  def set_review
    @review = Review.find(params[:id])
  end

  # Проверяем, принадлежит ли отзыв текущему пользователю
  def check_owner
    unless @review.user == current_user
      redirect_to root_path, alert: 'У вас нет прав для выполнения этого действия.'
    end
  end

  # Разрешаем параметры для отзыва
  def review_params
    params.require(:review).permit(:rating, :text)
  end
end