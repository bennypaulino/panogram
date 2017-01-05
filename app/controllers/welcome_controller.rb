class WelcomeController < ApplicationController
  def index
    if logged_in?
      @micropost = current_user.microposts.build
      @comment = @micropost.comments.build
      @feed_items = current_user.feed.paginate(page: params[:page],
                                                     per_page: 10)
    end
  end
end
