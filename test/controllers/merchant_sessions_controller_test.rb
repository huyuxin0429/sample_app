require "test_helper"

class MerchantSessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get merchant_login_path
    assert_response :success
  end
end
