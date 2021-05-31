require "test_helper"

class MerchantsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get merchants_new_url
    assert_response :success
  end
end
