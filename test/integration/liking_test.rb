require 'test_helper'

class LikingTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:lebowski)
    @micropost = microposts(:bar)
    @comment = @micropost.comments.build
    log_in_as(@user)
  end

  test "show_liked_posts" do
    assert @user.likes.empty?
    @user.like_post(@micropost)
    get liked_posts_user_path(@user)
    assert_not @user.likes.empty?
    assert_match @user.likes.count.to_s, response.body
    @user.liked_posts.each do |post|
      assert_select "a[href=?]", user_path
    end
  end
end
