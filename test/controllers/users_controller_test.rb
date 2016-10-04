require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:krusty)
    @base_title = "Because the world isn't always square"
  end

  test "should get new" do
    get new_user_path
    assert_response :success
  end

  test "should get signup" do
    get new_user_path
    assert_response :success
    assert_select "title", "Sign Up | #{@base_title}"
  end

  test "should redirect edit page when not logged in" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect any attempt to update a profile when not logged in" do
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end
end
