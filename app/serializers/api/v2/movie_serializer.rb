module Api
  module V2
    class MovieSerializer
      include FastJsonapi::ObjectSerializer

      attributes :title
      belongs_to :genre
    end
  end
end
