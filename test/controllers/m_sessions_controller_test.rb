require "test_helper"

class MSessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get m_sessions_new_url
    assert_response :success
  end
end
