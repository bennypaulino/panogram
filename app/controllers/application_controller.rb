class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  private

  # Confirms a logged-in user.
  def logged_in_user
    unless logged_in?
      store_location # saves the requested url, if it's a GET request
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end
end
