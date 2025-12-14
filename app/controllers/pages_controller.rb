class PagesController < ApplicationController
  def home
    # Можно добавить несколько последних отзывов на главную
    @reviews = Review.includes(:user, :reviewable).order(created_at: :desc).limit(5) if Review.table_exists?
  end

  def books
    # Этот метод будет обновлен на следующем этапе
  end

  def movies
    # Этот метод будет обновлен на следующем этапе
  end

  # Временный метод для отображения книги
  def book_show
    # Создаем заглушку для книги
    @book = OpenStruct.new(
      id: params[:id],
      title: "Тестовая книга #{params[:id]}",
      author: "Автор книги #{params[:id]}",
      description: "Это тестовое описание книги #{params[:id]}. Здесь будет настоящее описание, когда создадим модель Book.",
      # Методы для совместимости с Review
      reviews: [],  # Пока пустой массив отзывов
      average_rating: 0,  # Средний рейтинг
      reviews_count: 0  # Количество отзывов
    )
    
    # Загружаем реальные отзывы, если таблица существует
    if Review.table_exists?
      @reviews = Review.where(reviewable_type: 'Book', reviewable_id: params[:id])
                       .includes(:user)
                       .order(created_at: :desc)
      @book.reviews_count = @reviews.count
      
      # Рассчитываем средний рейтинг
      if @reviews.any?
        @book.average_rating = @reviews.average(:rating).round(1)
      end
    else
      @reviews = []
    end
    
    # Форма для нового отзыва
    @review = Review.new
    
    render 'books/show'
  end

  # Временный метод для отображения фильма
  def movie_show
    # Создаем заглушку для фильма
    @movie = OpenStruct.new(
      id: params[:id],
      title: "Тестовый фильм #{params[:id]}",
      director: "Режиссер фильма #{params[:id]}",
      description: "Это тестовое описание фильма #{params[:id]}. Здесь будет настоящее описание, когда создадим модель Movie.",
      # Методы для совместимости с Review
      reviews: [],  # Пока пустой массив отзывов
      average_rating: 0,  # Средний рейтинг
      reviews_count: 0  # Количество отзывов
    )
    
    # Загружаем реальные отзывы, если таблица существует
    if Review.table_exists?
      @reviews = Review.where(reviewable_type: 'Movie', reviewable_id: params[:id])
                       .includes(:user)
                       .order(created_at: :desc)
      @movie.reviews_count = @reviews.count
      
      # Рассчитываем средний рейтинг
      if @reviews.any?
        @movie.average_rating = @reviews.average(:rating).round(1)
      end
    else
      @reviews = []
    end
    
    # Форма для нового отзыва
    @review = Review.new
    
    render 'movies/show'
  end
end