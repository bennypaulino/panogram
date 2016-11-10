require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest

  def setup
    @base_title = "Because the world isn't always square"
    @user = users(:krusty)
  end

  test "should get home" do
    log_in_as @user
    get home_path
    assert_response :success
    assert_select "title", "Panogram | #{@base_title}"
  end

  test "should redirect user that isn't logged in attempting to access home" do
    get home_path
    assert_redirected_to root_url
  end

  test "should get help" do
    get help_path
    assert_response :success
    assert_select "title", "Panogram Help | #{@base_title}"
  end

  test "should get about" do
    get about_path
    assert_response :success
    assert_select "title", "About Panogram | #{@base_title}"
  end

  test "should get contact" do
    get contact_path
    assert_response :success
    assert_select "title", "Contact Panogram | #{@base_title}"
  end
end
