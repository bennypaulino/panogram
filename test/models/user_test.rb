require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "Joe Schmoe", email: "joe@schmoe.com")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "a name should be present" do
    @user.name = "   "
    assert_not @user.valid?
  end

  test "an email address should be present" do
    @user.email = "   "
    assert_not @user.valid?
  end
end
