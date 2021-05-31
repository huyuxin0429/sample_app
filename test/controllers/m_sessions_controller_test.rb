require "test_helper"

class MSessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get mlogin_path
    assert_response :success
  end
end
