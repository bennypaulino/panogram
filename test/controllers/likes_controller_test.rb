require 'test_helper'

class LikesControllerTest < ActionDispatch::IntegrationTest

  test "create should require a logged-in user" do
    assert_no_difference 'Like.count' do
      post likes_path
    end
    assert_redirected_to login_url
  end

  # test "destroy should require a logged-in user" do
  #   assert_no_difference 'Like.count' do
  #     delete likes_path(likes(:one))
  #   end
  #   assert_redirected_to login_url
  # end
end
