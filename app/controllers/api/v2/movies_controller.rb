module Api
  module V2
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
        render json: MovieSerializer.new(@movies, include: [:genre])
      end
    end
  end
end
