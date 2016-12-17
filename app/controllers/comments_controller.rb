class CommentsController < ApplicationController
  before_action :find_commentable
  before_action :logged_in_user
  #before_action :correct_user, only: [:update, :destroy]

  def create
    @comment = @commentable.comments.build(comment_params)
    if @comment.save
      # provide a handle for the comments view
      @micropost_id = find_micropost_id(@comment)
      @micropost = find_micropost(@comment)
      respond_to do |format|
        format.html { redirect_to root_url }
        format.js
      end
    else
      redirect_to :back, notice: "Your comment wasn't posted!"
    end
  end

  # def show
  #   micropost = Micropost.find(params[:micropost_id])
  #   @comments = micropost.comments
  # end

  private

  def find_micropost_id(comment)
    return comment.commentable_id if comment.commentable_type == "Micropost"
    find_micropost_id(Comment.find_by_id(comment.commentable_id))
  end

  def find_micropost(comment)
    if comment.commentable_type == "Micropost"
      return @micropost = Micropost.find_by_id(comment.commentable_id)
    else
      n = find_micropost_id(comment)
      return @micropost = Micropost.find_by_id(n)
    end
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def find_commentable
    @commentable = if params[:comment][:commentable_type] == "Comment"
                     Comment.find_by_id(params[:comment][:commentable_id])
                   elsif params[:comment][:commentable_type] == "Micropost"
                     Micropost.find_by_id(params[:comment][:commentable_id])
                   end
  end
end
