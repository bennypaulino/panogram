require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

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
    follow_redirect!
    assert_template 'users/show'
    assert_not flash.empty?
    assert is_logged_in?
  end
end
