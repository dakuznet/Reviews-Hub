class MoviesController < ApplicationController
  before_action :set_movie, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, except: %i[ index show ]
  before_action :check_owner, only: %i[ edit update destroy ]

  # GET /movies или /movies.json
  def index
    @movies = Movie.includes(:user, :reviews)
                   .search(params[:search])
                   .order(created_at: :desc)
    
    if params[:genre].present?
      @movies = @movies.where("genre ILIKE ?", "%#{params[:genre]}%")
    end
    
    if params[:country].present?
      @movies = @movies.where("country ILIKE ?", "%#{params[:country]}%")
    end
    
    @genres = Movie.pluck(:genre).compact.uniq.sort
    @countries = Movie.pluck(:country).compact.uniq.sort
  end

  # GET /movies/1 или /movies/1.json
  def show
    @reviews = @movie.reviews.includes(:user).order(created_at: :desc)
    @review = Review.new
  end

  # GET /movies/new
  def new
    @movie = Movie.new
  end

  # GET /movies/1/edit
  def edit
  end

  # POST /movies или /movies.json
  def create
    @movie = Movie.new(movie_params)
    @movie.user = current_user

    respond_to do |format|
      if @movie.save
        format.html { redirect_to movie_url(@movie), notice: "Фильм успешно создан." }
        format.json { render :show, status: :created, location: @movie }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /movies/1 или /movies/1.json
  def update
    respond_to do |format|
      if @movie.update(movie_params)
        format.html { redirect_to movie_url(@movie), notice: "Фильм успешно обновлен." }
        format.json { render :show, status: :ok, location: @movie }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /movies/1 или /movies/1.json
  def destroy
    @movie.destroy!

    respond_to do |format|
      format.html { redirect_to movies_url, notice: "Фильм успешно удален." }
      format.json { head :no_content }
    end
  end

  private
  
  def set_movie
    @movie = Movie.find(params[:id])
  end

  def check_owner
    unless @movie.user == current_user
      redirect_to movies_url, alert: "Вы не можете редактировать или удалять чужой фильм."
    end
  end

  def movie_params
    params.require(:movie).permit(:title, :director, :screenwriter, :producer, :year, 
                                  :genre, :description, :url, :duration, :country, :studio)
  end
end