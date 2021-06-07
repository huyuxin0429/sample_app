require "test_helper"

class MicropostTest < ActiveSupport::TestCase
  def setup
    @user = users(:michael)

    # Not idiomatically correct
    # @micropost = Micropost.new(content: "Test text", user_id: @user.id)
    @micropost = @user.microposts.build(content: "Test text")
  end

  test "should be valid" do
    assert @micropost.valid?
  end

  test "should have user id" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  test "content should be present" do
    @micropost.content = " "
    assert_not @micropost.valid?
  end

  test "content should be at most 140 characters" do
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end

  test "order should be most recent" do
    assert_equal microposts(:most_recent), Micropost.first
  end


end
