require "rails_helper"

describe "/api/v1/movies" do
  let(:json_response) { JSON.parse(response.body) }

  describe "GET /" do
    let!(:movies) { create_list(:movie, 2) }

    before { get "/api/v1/movies" }

    it "returns all records with expected attributes" do
      expect(json_response["data"].count).to eq(2)
      expect(json_response["data"].map { |x| x["attributes"]["title"] }).to match_array(movies.map(&:title))
    end

    it "responds with application/json header" do
      expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
    end
  end

  describe "GET /:id" do
    let!(:movie) { create(:movie) }

    before { get "/api/v1/movies/#{movie.id}" }

    it "returns requested movie" do
      expect(json_response["data"]["id"]).to eq(movie.id.to_s)
      expect(json_response["data"]["attributes"]["title"]).to eq(movie.title)
    end
  end
end

