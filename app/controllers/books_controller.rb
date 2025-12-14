class BooksController < ApplicationController
  before_action :set_book, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, except: %i[ index show ]
  before_action :check_owner, only: %i[ edit update destroy ]

  # GET /books или /books.json
  def index
    @books = Book.includes(:user, :reviews)
                 .search(params[:search])
                 .order(created_at: :desc)
    
    # Фильтрация по жанру
    if params[:genre].present?
      @books = @books.where("genre ILIKE ?", "%#{params[:genre]}%")
    end
    
    # Собираем все жанры для фильтра
    @genres = Book.pluck(:genre).compact.uniq.sort
  end

  # GET /books/1 или /books/1.json
  def show
    @reviews = @book.reviews.includes(:user).order(created_at: :desc)
    @review = Review.new
  end

  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1/edit
  def edit
  end

  # POST /books или /books.json
  def create
    @book = Book.new(book_params)
    @book.user = current_user

    respond_to do |format|
      if @book.save
        format.html { redirect_to book_url(@book), notice: "Книга успешно создана." }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /books/1 или /books/1.json
  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to book_url(@book), notice: "Книга успешно обновлена." }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1 или /books/1.json
  def destroy
    @book.destroy!

    respond_to do |format|
      format.html { redirect_to books_url, notice: "Книга успешно удалена." }
      format.json { head :no_content }
    end
  end

  private
  
  def set_book
    @book = Book.find(params[:id])
  end

  def check_owner
    unless @book.user == current_user
      redirect_to books_url, alert: "Вы не можете редактировать или удалять чужую книгу."
    end
  end

  def book_params
    params.require(:book).permit(:title, :author, :publisher, :year, :edition, :genre, :description, :url)
  end
end