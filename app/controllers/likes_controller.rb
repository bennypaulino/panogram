 # require.pry
class LikesController < ApplicationController
  before_action :logged_in_user


  def create
    #@user = current_user
    @micropost = Micropost.find(params[:micropost_id])
    current_user.like_post(@micropost)

    respond_to do |format|
      format.html { redirect_to current_user }
      format.js
    end
  end

  def destroy
    #binding.pry
    @liked_post = Like.find(params[:id])
    if @liked_post.present?
      @liked_post.destroy
      #@user.dislike(@micropost)
    end

    #@user.dislike(@micropost)
    respond_to do |format|
      format.html { redirect_to current_user }
      format.js
    end
  end
end
