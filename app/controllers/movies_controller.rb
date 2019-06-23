class MoviesController < ApplicationController
  before_action :authenticate_user!, only: [:send_info]

  def index
    @movies = Movie.all.decorate
  end

  def show
    @movie = Movie.find(params[:id]).decorate
  end

  def send_info
    @movie = Movie.find(params[:id])
    MovieInfoMailer.send_info(current_user, @movie).deliver_later
    redirect_back(fallback_location: root_path, notice: "Email with movie details will be delivered soon.")
  end

  def export
    file_path = "tmp/movies.csv"
    ExportMoviesJob.perform_later(current_user.id, file_path)
    redirect_to root_path, notice: "Movies exported"
  end
end
