require "rails_helper"

describe PairguruApiGateway do
  describe "#get_movie" do
    subject { described_class.new.get_movie("Kill Bill") }

    it "fetches movie from cache with slug based key" do
      expect(Rails.cache).to receive(:fetch).with("pairguru-api/movie/Kill%20Bill")

      subject
    end
  end
end

