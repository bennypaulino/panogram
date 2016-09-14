require 'test_helper'

class WelcomeControllerTest < ActionDispatch::IntegrationTest

  def setup
    @base_title = "Because the world isn't always square"
  end

  test "should get root" do
    get root_url
    assert_response :success
    assert_select "title", "Panogram | #{@base_title}"
  end
end
