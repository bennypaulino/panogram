require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:krusty)
    @non_admin = users(:vader)
    @unactivated_user = users(:unactivated)
  end

  test "viewing the index page as admin includes pagination and delete links" do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination', count: 2
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
      if user.activated?
        assert_select 'a[href=?]', user_path(user), text: user.username
        unless user == @admin
          assert_select 'a[href=?]', user_path(user), text: 'delete'
        end
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end

  test "viewing the index page as a non-admin" do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end

  test "index page should not list users that are not activated" do
    log_in_as(@non_admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination', count: 2
    first_page_of_users = User.paginate(page: 1)
    second_page_of_users = User.paginate(page: 2)
    first_page_of_users.each do |user|
        assert_select 'a[href=?]', user_path(@unactivated_user), count: 0
    end
    second_page_of_users.each do |user|
        assert_select 'a[href=?]', user_path(@unactivated_user), count: 0
    end
  end
end
