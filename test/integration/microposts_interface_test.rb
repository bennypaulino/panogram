require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:krusty)
  end

  test "micropost interface" do
    log_in_as(@user)
    get home_path
    assert_select 'div.pagination'
    assert_select 'input[type="file"]'

    # Invalid submission
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: "" } }
    end
    assert_select 'div#error_explanation'

    # Valid submission
    content = "This micropost really ties the room together!"
    picture = fixture_file_upload('test/fixtures/donkey_kong.png', 'image/png')
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: { micropost: { content: content,
                                                   picture: picture } }
    end
    assert_response :success
    assert_template :crop
    #most_recent = assigns(:micropost)
    #assert most_recent.picture?
    # previous two lines are the same as saying the following:
    assert @user.microposts.first.picture?

    # request to edit picture
    patch micropost_path(@user.microposts.first), params: { "micropost"=>
                                                  {"crop_x"=>"239",
                                                   "crop_y"=>"21",
                                                   "crop_w"=>"256",
                                                   "crop_h"=>"274"} }

    assert_redirected_to home_path
    follow_redirect!
    assert_match content, response.body

    # Delete post
    assert_select 'a', text: 'delete'
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end

    # Visit different user (no delete links)
    get user_path(users(:lebowski))
    assert_select 'a', text: 'delete', count: 0
  end

  test "micropost sidebar count" do
    log_in_as(@user)
    get home_path
    assert_match "35 pano-posts", response.body

    # User with zero microposts
    other_user = users(:kenobi)
    log_in_as(other_user)
    get home_path
    assert_match "0 pano-posts", response.body
    other_user.microposts.create!(content: "That's no moon, it's a space station!")
    get home_path
    assert_match "1 pano-post", response.body
  end
end
