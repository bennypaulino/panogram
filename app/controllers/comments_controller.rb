class CommentsController < ApplicationController
  before_action :set_micropost
  before_action :logged_in_user

  def create
    @comment = @micropost.comments.build(comment_params)
    @comment.user_id = current_user.id
    @comment.parent_id = params[:comment][:parent_id]
    if @comment.save
      respond_to do |format|
        format.html { redirect_to @micropost }
        format.js
      end
    else
      flash[:danger] = "Your comment wasn't posted!"
      redirect_to :back
    end
  end

  def new
    @parent = Comment.find(params[:parent_id])
    # micropost = @parent.commentable
    # micropost_id = micropost.id
    @comment = Comment.build(comment_params)
    @comment.parent_id = @parent.id
    # respond_to do |format|
    #   format.js {}
    # end
  end

  # def show
  #   micropost = Micropost.find(params[:micropost_id])
  #   @comments = micropost.comments
  # end

  private

  def comment_params
    params.require(:comment).permit(:body, :micropost_id, :user_id)
  end

  def set_micropost
    @micropost = Micropost.find params[:micropost_id]
  end
end
