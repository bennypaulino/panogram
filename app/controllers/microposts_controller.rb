class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy, :update]
  before_action :correct_user, only: [:update, :destroy]

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      if params[:micropost][:picture].present?
        render :crop
      else
        flash[:success] = "New panogram created!"
        redirect_to home_path # request.referrer || root_url
      end
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    redirect_back(fallback_location: root_url)
    # same as: redirect_to request.referrer || root_url
    # request.referrer is the previous URL
  end

  def update
    @micropost = current_user.microposts.first
    if @micropost.update_attributes(micropost_params)
      if params[:micropost][:picture].present?
        render :crop
      else
        flash[:success] = "New panogram created!"
        redirect_to home_path
      end
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  private

  def micropost_params
    params.require(:micropost).permit(:content, :picture, :crop_x,
                                      :crop_y, :crop_w, :crop_h)
  end

  # Checks that the current user actually has a micropost with the given id.
  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    redirect_to root_url if @micropost.nil?
  end
end
