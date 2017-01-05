class UsersController < ApplicationController
  before_action :logged_in_user, except: [:new, :create]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    redirect_to root_url and return unless @user.activated?
    @micropost = current_user.microposts.build
    @comment = @micropost.comments.build
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
       flash[:success] = "Your profile has been updated"
       redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User successfully deleted"
    redirect_to users_url
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  def liked_posts
    @title = "Liked Panograms"
    @user = User.find(params[:id])
    @micropost = current_user.microposts.build
    @comment = @micropost.comments.build
    @panoposts = @user.liked_posts.paginate(page: params[:page])
    render 'show_liked_posts'
  end

  def likes
    @title = "Likes"
    @user = User.find(params[:id])
    @panoposts = @user.likes.paginate(page: params[:page])
    render 'show_liked_posts'
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :username, :password,
                                 :password_confirmation)
  end

  # Before filters

  # Confirms the correct user.
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  # Confirms that the current user is an admin
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
