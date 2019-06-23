module Api
  module V1
    class MoviesController < ApiController
      def index
        movies = Movie.all

        render json: MovieSerializer.new(movies)
      end

      def show
        movie = Movie.find(params[:id])

        render json: MovieSerializer.new(movie)
      end
    end
  end
end
