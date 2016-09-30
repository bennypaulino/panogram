class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def signup
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Hi, #{@user.username.upcase}, welcome to Panogram!"
      redirect_to @user
    else
      render 'new'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :username, :password,
                                 :password_confirmation)
  end
end
