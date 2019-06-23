module Api
  module V1
    class MovieSerializer
      include FastJsonapi::ObjectSerializer

      attributes :title
    end
  end
end
