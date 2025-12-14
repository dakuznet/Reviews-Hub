require "test_helper"

class MoviesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @movie = movies(:one)
  end

  test "should get index" do
    get movies_url
    assert_response :success
  end

  test "should get new" do
    get new_movie_url
    assert_response :success
  end

  test "should create movie" do
    assert_difference("Movie.count") do
      post movies_url, params: { movie: { country: @movie.country, description: @movie.description, director: @movie.director, duration: @movie.duration, genre: @movie.genre, producer: @movie.producer, screenwriter: @movie.screenwriter, studio: @movie.studio, title: @movie.title, url: @movie.url, user_id: @movie.user_id, year: @movie.year } }
    end

    assert_redirected_to movie_url(Movie.last)
  end

  test "should show movie" do
    get movie_url(@movie)
    assert_response :success
  end

  test "should get edit" do
    get edit_movie_url(@movie)
    assert_response :success
  end

  test "should update movie" do
    patch movie_url(@movie), params: { movie: { country: @movie.country, description: @movie.description, director: @movie.director, duration: @movie.duration, genre: @movie.genre, producer: @movie.producer, screenwriter: @movie.screenwriter, studio: @movie.studio, title: @movie.title, url: @movie.url, user_id: @movie.user_id, year: @movie.year } }
    assert_redirected_to movie_url(@movie)
  end

  test "should destroy movie" do
    assert_difference("Movie.count", -1) do
      delete movie_url(@movie)
    end

    assert_redirected_to movies_url
  end
end
