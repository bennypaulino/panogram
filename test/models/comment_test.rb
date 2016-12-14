require 'test_helper'

class CommentTest < ActiveSupport::TestCase

  def setup
    user = users(:krusty)
    @comment = user.comments.build(body: "Ha, ha!")
  end

  test "should be valid" do
    assert @comment.valid?
  end

  test "comment body should be present" do
    @comment.body = " "
    assert_not @comment.valid?
  end

  test "comment body should be at most 220 characters" do
    @comment.body = "b" * 221
    assert_not @comment.valid?
  end
end
