require "test_helper"

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get home_url
    assert_response :success
    assert_select "title", "DrDelivery"
  end

  test "should get help" do
    get help_url
    assert_response :success
    assert_select "title", "Help | DrDelivery"
  end

  test "should get about" do
    get about_url
    assert_response :success
    assert_select "title", "About | DrDelivery"
  end

  test "should get contact" do
    get contact_url
    assert_response :success
    assert_select "title", "Contact | DrDelivery"
  end
end
