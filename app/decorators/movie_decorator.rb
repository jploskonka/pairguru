class MovieDecorator < Draper::Decorator
  delegate_all

  def cover
    [ PairguruApiGateway::API_HOST, api_attributes["poster"] ]
      .join("")
  end

  def plot
    api_attributes["plot"]
  end

  def rating
    api_attributes["rating"]
  end

  def headline
    "#{title} / #{rating}"
  end

  private

  def api_attributes
    PairguruApiGateway.new
      .get_movie(title)
      .dig("data", "attributes")
  end
end
