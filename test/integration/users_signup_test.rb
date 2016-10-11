require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  # Reset the deliveries array to prevent the code from breaking if any other
  # tests deliver email.
  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "invalid signup information" do
    get signup_path
    assert_select 'form[action="/signup"]'
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name: "",
                                          email: "user@invalid",
                                          username: "",
                                          password: "boo",
                                          password_confirmation: "hoo" } }
    end
    assert_template 'users/new'
    assert_select "li", "Name can't be blank"
    assert_select "li", "Email is invalid"
    assert_select "li", "Username can't be blank"
    assert_select "li", "Password confirmation doesn't match Password"
    assert_select "div#error_explanation"
    assert_select 'div.field_with_errors'
  end

  test "Successful registration with valid signup information" do
    get signup_path
    assert_select 'form[action="/signup"]'
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: "Boaty McBoatface",
                                         email: "boaty@motorboating.com",
                                         username: "boaty_mcboatface",
                                         password: "riverboat",
                                         password_confirmation: "riverboat" } }
    end
    # Verify that exactly one message was delivered:
    assert_equal 1, ActionMailer::Base.deliveries.size

    # Access the instance variable @user from within the create action that
    # belongs to users_controller.rb by using assigns(:user)
    user = assigns(:user)
    assert_not user.activated?

    #Try to log in before activation
    log_in_as(user)
    assert_not is_logged_in?

    # Provide an invalid activation token
    get edit_account_activation_path("invalid token", email: user.email)
    assert_not is_logged_in?

    # Provide a valid token, but the wrong email
    get edit_account_activation_path(user.activation_token, email: 'wrong email')
    assert_not is_logged_in?

    # Valid token && valid email
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert_not flash.empty?
    assert is_logged_in?
  end
end
