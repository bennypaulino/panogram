require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:krusty)
    @evil_user = users(:vader)
    @base_title = "Because the world isn't always square"
  end

  test "should redirect if visiting index when not logged in" do
    get users_path
    assert_redirected_to login_url
  end

  test "should get index for a user that is logged in" do
    log_in_as(@user)
    get users_path
    assert_template 'users/index'
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

  test "should redirect when accessing someone else's edit profile page" do
    log_in_as(@evil_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect an attempt to UPDATE someone else's profile page" do
    log_in_as(@evil_user)
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should not allow the admin attribute to be edited via the web" do
    log_in_as(@evil_user)
    assert_not @evil_user.admin?
    patch user_path(@evil_user), params: {
                               user: { password: 'password',
                                       password_confirmation: 'password',
                                       admin: true } }
    assert_not @evil_user.reload.admin?
  end

  test "should redirect destroy when a user is not logged in" do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when a non-admin user is logged in" do
    log_in_as(@evil_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to root_url
  end
end