class CommentsController < ApplicationController
  def create
    comment = Comment.create(comment_params)

    if comment.save
      redirect_to movie_path(comment.movie), notice: "Your comment was added."
    else
      redirect_to movie_path(comment.movie), alert: "You can't comment twice on the same movie. Please remove your previous comment and try again."
    end
  end

  def destroy
    comment = Comment.find(params[:id])
    comment.destroy

    redirect_to movie_path(comment.movie), notice: "Your comment was destroyed."
  end

  private

  def comment_params
    params.require(:comment).permit(:user_id, :movie_id, :content)
  end
end
