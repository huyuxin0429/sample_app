require "test_helper"

class MerchantsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get msignup_path
    assert_response :success
  end
end
