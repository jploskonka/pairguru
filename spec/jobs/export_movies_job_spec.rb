require "rails_helper"

describe ExportMoviesJob do
  describe "#perform" do
    let!(:user)          { create(:user) }
    let(:file_path)      { "tmp/foo.csv" }

    subject(:job) { described_class.new }

    it "calls MovieExporter" do
      expect_any_instance_of(MovieExporter).to receive(:call)
        .with(user, file_path)

      job.perform(user.id, file_path)
    end
  end
end
