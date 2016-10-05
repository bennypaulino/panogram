require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:krusty)
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name: "",
                                              email: "invalid@email",
                                              password: "not",
                                              password_confirmation: "good"} }
    assert_template 'users/edit'
    assert_select "div.alert", "The form contains 4 errors"
  end

  test "successful edit with friendly forwarding" do
    # Submit first page request
    get edit_user_path(@user)

    # User isn't logged in, requested URL stored in session[:forwarding_url]
    assert_redirected_to login_url
    log_in_as(@user)

    # User is now logged in & should be redirected to the URL
    # stored in session[:forwarding_url]
    assert_redirected_to edit_user_path(@user)
    # sessions[:forwarding_url] should now be nil, because of the last
    # line of redirect_back_or method within sessions_helper.rb

    name = "Krusty the Clown"
    email = "krusty@theclown.com"
    patch user_path(@user), params: { user: { name: name, email: email,
                                              password: "",
                                              password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email

    # Verify that the method, redirect_back_or, is set to nil.
    assert_nil session[:forwarding_url]

    # On subsequent login attempts, user should be redirected to their profile
  end
end
