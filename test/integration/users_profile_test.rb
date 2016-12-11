require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:krusty)
  end

  test "profile display" do
    log_in_as(@user)
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.username)
    assert_select 'h1', text: @user.username
    assert_select 'h1>img.gravatar'
    assert_select 'div.stats'
    assert_match @user.following.count.to_s, response.body
    assert_match @user.followers.count.to_s, response.body
    assert_match @user.microposts.count.to_s, response.body
    assert_select 'div.pagination', count: 1
    @user.microposts.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body
    end
  end
end
