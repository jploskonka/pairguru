require "rails_helper"

describe User do
  it { is_expected.to allow_value("+48 999 888 777").for(:phone_number) }
  it { is_expected.to allow_value("48 999-888-777").for(:phone_number) }
  it { is_expected.to allow_value("48 999-888-777").for(:phone_number) }
  it { is_expected.not_to allow_value("+48 aaa bbb ccc").for(:phone_number) }
  it { is_expected.not_to allow_value("aaa +48 aaa bbb ccc").for(:phone_number) }
  it { is_expected.not_to allow_value("+48 999 888 777\naseasd").for(:phone_number) }

  describe ".top_commenters" do
    let!(:movies) { create_list(:movie, 2) }
    let!(:users)  { create_list(:user, 3) }

    let!(:comments_u1) do
      movies.each { |m| create(:comment, user: users[0], movie: m) }
    end

    let!(:comments_u2) do
      create(:comment, user: users[1], movie: movies.first)
    end

    let!(:comments_u3) do
      create(:comment, user: users[2] , movie: movies.first, created_at: 8.days.ago)
    end

    subject(:top_commenters) { described_class.top_commenters }

    it do
      expect(top_commenters.map(&:id)).to match_array([users[0].id, users[1].id])
      expect(top_commenters.first.comments_count).to eq(2)
      expect(top_commenters.last.comments_count).to eq(1)
    end
  end
end
