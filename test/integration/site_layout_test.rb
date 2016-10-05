require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:krusty)
  end

  test "layout links" do
    get root_path
    assert_template '/'
    assert_select "a[href=?]", root_path, count: 3
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", signup_path

    # Reveal links that will show up once a user is signed in...
    log_in_as(@user)
    get root_path
    assert_select "a[href=?]", users_path
    assert_select "a[href=?]", user_path(@user) #profile
    assert_select "a[href=?]", edit_user_path(@user) #settings
    assert_select "a[href=?]", logout_path
  end
end
