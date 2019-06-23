require "rails_helper"

describe "Movies requests", type: :request do
  shared_examples "movie details view" do |movie_title:, fixture_file_name:|
    let(:fixture_content) { file_fixture(fixture_file_name).read }
    let(:expected_json)   { JSON.parse(fixture_content)["data"]["attributes"] }

    it "displays poster" do
      expect(page).to have_css("img[@src='#{PairguruApiGateway::API_HOST}#{expected_json["poster"]}']")
    end

    it "displays rating" do
      expect(page).to have_text(expected_json["rating"])
    end

    it "displays plot" do
      expect(page).to have_text(expected_json["plot"])
    end
  end

  describe "movies list" do
    let!(:django)    { create(:movie, title: "Django") }
    let!(:kill_bill) { create(:movie, title: "Kill Bill") }

    before do
      stub_pairguru_get(/Django/, "django.json")
      stub_pairguru_get(/Kill Bill/, "kill_bill.json")

      visit "/movies"
    end

    it "displays right title" do
      expect(page).to have_selector("h1", text: "Movies")
    end

    it_behaves_like "movie details view",
      movie_title: "Django",
      fixture_file_name: "django.json"

    it_behaves_like "movie details view",
      movie_title: "Kill Bill",
      fixture_file_name: "kill_bill.json"
  end

  describe "show movie" do
    let!(:django) { create(:movie, title: "Django") }

    before do
      stub_pairguru_get(/Django/, "django.json")
      visit "/movies/#{django.id}"
    end

    it_behaves_like "movie details view",
      movie_title: "Django",
      fixture_file_name: "django.json"
  end

  describe "GET /:id/send_info" do
    let!(:user)   { create(:user) }
    let!(:django) { create(:movie, title: "Django") }

    before do
      stub_pairguru_get(/Django/, "django.json")
      login_as(user)
    end

    it "sends email via background job" do
      expect {
        get "/movies/#{django.id}/send_info"
        expect(ActionMailer::Base.deliveries.count).to eq(0)
      }.to have_enqueued_job(ActionMailer::DeliveryJob)
    end
  end

  describe "GET /export" do
    let!(:user)   { create(:user) }
    let!(:django) { create(:movie, title: "Django") }

    before do
      stub_pairguru_get(/Django/, "django.json")
      login_as(user)
    end

    it "enqueues export job" do
      expect {
        get "/movies/export"
        expect(ActionMailer::Base.deliveries.count).to eq(0)
      }.to have_enqueued_job(ExportMoviesJob).with(user.id, "tmp/movies.csv")
    end
  end
end
