require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
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

  # test "should get login" do
  #   get login_path
  #   assert_response :success
  # end

  # test "should get logout" do
  #   get logout_path
  #   assert_response :success
  # end

end
