module Api
  module V1
    class MoviesController < ApiController
      def index
        @movies = Movie.all
        render_movies
      end

      def show
        @movies = Movie.find(params[:id])
        render_movies
      end

      private

      def render_movies
        render json: MovieSerializer.new(@movies)
      end
    end
  end
end
