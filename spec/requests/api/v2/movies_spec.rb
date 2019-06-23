require "rails_helper"

describe "/api/v2/movies" do
  let(:json_response) { JSON.parse(response.body) }

  describe "GET /" do
    let!(:movies)   { create_list(:movie, 2) }
    let(:genre_ids) { movies.map(&:genre_id).map(&:to_s) }

    before { get "/api/v2/movies" }

    it "returns all movies with included genre data" do
      expect(json_response["data"].count).to eq(2)
      expect(json_response["data"].map { |x| x["attributes"]["title"] }).to match_array(movies.map(&:title))
      expect(json_response["included"].map { |x| x["id"] }).to match_array(genre_ids)
    end

    it "responds with application/json header" do
      expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
    end
  end

  describe "GET /:id" do
    let!(:movie) { create(:movie) }

    before { get "/api/v2/movies/#{movie.id}" }

    it "returns requested movie with genre details" do
      expect(json_response["data"]["id"]).to eq(movie.id.to_s)
      expect(json_response["data"]["attributes"]["title"]).to eq(movie.title)
      expect(json_response["included"][0]["attributes"]["name"]).to eq(movie.genre.name)
      expect(json_response["included"][0]["attributes"]["movies_count"]).to eq(1)
    end
  end
end
