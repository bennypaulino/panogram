require 'test_helper'

class MicropostsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @micropost = microposts(:costello)
  end

  test "should redirect an attempt to create when user isn't logged in" do
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: "Not logged in" } }
    end
    assert_redirected_to login_url
  end

  test "should redirect attempt to destroy a post when user isn't logged in" do
    assert_no_difference 'Micropost.count' do
      delete micropost_path(@micropost)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy for wrong micropost" do
    log_in_as(users(:krusty))
    micropost = microposts(:marmot)
    assert_no_difference 'Micropost.count' do
      delete micropost_path(micropost)
    end
    assert_redirected_to root_url
  end

  test "should redirect attempt to access admirers page when not logged in" do
    get admirers_micropost_path(@micropost)
    assert_redirected_to login_url
  end
end
