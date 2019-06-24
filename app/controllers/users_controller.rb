class UsersController < ApplicationController
  def top_commenters
    @commenters = User.top_commenters
  end
end
