module Api
  module V2
    class GenreSerializer
      include FastJsonapi::ObjectSerializer

      attribute :name
      attribute :movies_count do |genre|
        genre.movies.count
      end
    end
  end
end
