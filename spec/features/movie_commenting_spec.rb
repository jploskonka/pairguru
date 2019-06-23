require "rails_helper"

feature "Commenting movies" do
  let!(:movie)         { create(:movie) }
  let!(:user_me)       { create(:user) }
  let!(:user_other)    { create(:user) }
  let!(:comment_other) { create(:comment, movie: movie, user: user_other)  }

  background do
    stub_pairguru_get(/#{movie.title}/, "django.json")
    login_as(user_me)
  end

  scenario "User visits movie with comment from others and adds his own" do
    visit "/movies/#{movie.id}"
    expect(page).to have_text(comment_other.content)

    fill_in "comment[content]", with: "Awesome movie!"
    click_button("Submit")

    expect(page).to have_text("Your comment was added.")
    expect(page).to have_text("Awesome movie!")
  end

  scenario "User comments on movie they've already commented" do
    create(:comment, movie: movie, user: user_me)
    visit "/movies/#{movie.id}"

    fill_in "comment[content]", with: "Awesome movie!"
    click_button("Submit")

    expect(page).to_not have_text("Awesome movie!")
    expect(page).to have_text("You can't comment twice on the same movie.")
  end
end
