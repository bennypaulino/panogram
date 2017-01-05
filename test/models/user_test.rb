require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "Joe Schmoe", email: "joe@schmoe.com",
                     username: "herpaderpa", password: "d0nuts",
                     password_confirmation: "d0nuts")
    @micropost = microposts(:marmot)
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

  test "a username should be present" do
    @user.username = "   "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  # there’s a (remote) chance that a user’s email address could overrun the
  # maximum length of a string, which for many databases is 255
  test "email address should not be too long" do
    @user.email = "b" * 244 + "@example.com" # => length = 256
    assert_not @user.valid?
  end

  test "username should not be too long" do
    @user.username = "c" * 51
    assert_not @user.valid?
  end

  test "email validation should accept VALID addresses" do
    valid_addresses = %w[user@example.com USER@blah.COM A_US-ER@hmm.whatever.org
                          first.last@sushisammich.jp grumpy+cat@nope.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should REJECT invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_whatever.org
                           user.name@example. dog@slob_ber.com ham@sam+mich.com
                            herpa@derpa..com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email addresses should be saved as lower-case" do
    mixed_case_email = "nOtsoCOOL@blaH.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test "usernames should be unique" do
    dummy_user = @user.dup
    dummy_user.username = @user.username.upcase
    @user.save
    assert_not dummy_user.valid?
  end

  test "usernames should be saved as lower-case" do
    camelCase_username = "herpyMcDerpy"
    @user.username = camelCase_username
    @user.save
    assert_equal camelCase_username.downcase, @user.reload.username
  end

  test "password should not be blank" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end

  test "associated microposts should be destroyed" do
    @user.save
    @user.microposts.create!(content: "Super offensive post")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end

  test "should follow and unfollow a user" do
    vader = users(:vader)
    maul = users(:maul)
    assert_not maul.following?(vader)
    maul.follow(vader)
    assert maul.following?(vader)
    assert vader.followers.include?(maul)
    maul.unfollow(vader)
    assert_not maul.following?(vader)
  end

  test "feed should have the right posts from followed users" do
    krusty = users(:krusty)
    lebowski = users(:lebowski)
    walter = users(:walter)

    # Posts from followed user
    walter.microposts.each do |post_following|
      assert lebowski.feed.include?(post_following)
    end

    # Posts from self
    lebowski.microposts.each do |post_self|
      assert lebowski.feed.include?(post_self)
    end

    # Posts from unfollowed user
    krusty.microposts.each do |post_unfollowed|
      assert_not lebowski.feed.include?(post_unfollowed)
    end
  end

  test "should like and unlike a micropost" do
    dude = users(:lebowski)
    walter = users(:walter)
    micropost = microposts(:pacifism)

    assert_not dude.liking?(micropost)
    dude.like_post(micropost)
    assert dude.liking?(micropost)
    assert micropost.admirers.include?(dude)
    dude.dislike(micropost)
    assert_not dude.liking?(micropost)
    assert micropost.reload.id > 0
  end

  test "associated comments should be destroyed" do
    @user.save
    @micropost.comments.create!(body: "Super offensive post", user_id: @user.id)
    assert_difference 'Comment.count', -1 do
      @user.destroy
    end
  end
end
