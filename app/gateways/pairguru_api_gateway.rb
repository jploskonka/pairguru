class PairguruApiGateway
  API_HOST = "https://pairguru-api.herokuapp.com/".freeze

  def initialize(client: HTTParty)
    @_client = client
  end

  def get_movie(title)
    Rails.cache.fetch(movie_cache_key(title)) do
      _client
        .get(movie_url(title))
        .parsed_response
    end
  end

  private

  attr_reader :_client

  def movie_url(title)
    [API_HOST, "api/v1/movies", movie_slug(title)].join("/")
  end

  def movie_slug(title)
    URI.encode(title)
  end

  def movie_cache_key(title)
    "pairguru-api/movie/#{movie_slug(title)}"
  end
end
