 # require.pry
class LikesController < ApplicationController
  before_action :logged_in_user


  def create
    @micropost = Micropost.find(params[:micropost_id])
    current_user.like_post(@micropost)

    respond_to do |format|
      format.html { redirect_to current_user }
      format.js
    end
  end

  def destroy
    @micropost = Micropost.find(params[:micropost_id])
    current_user.dislike(@micropost)

    respond_to do |format|
      format.html { redirect_to current_user }
      format.js
    end
  end
end
