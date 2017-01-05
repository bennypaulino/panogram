require 'test_helper'

class CommentTest < ActiveSupport::TestCase

  def setup
    user = users(:krusty)
    micropost = microposts(:marmot)
    @comment = micropost.comments.build(body: "Ha, ha!", user_id: user.id)
  end

  test "should be valid" do
    assert @comment.valid?
  end

  test "comment body should be present" do
    @comment.body = " "
    assert_not @comment.valid?
  end

  test "comment body should be at most 140 characters" do
    @comment.body = "b" * 141
    assert_not @comment.valid?
  end

  test "order should be newest comment first" do
    assert_equal comments(:question), Comment.last
    assert_equal comments(:most_recent), Comment.first
  end
end
