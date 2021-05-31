require "test_helper"

class MerchantsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @merchant = merchants(:michaelinc)
    @other_merchant = merchants(:archerinc)
  end
  test "should get new" do
    get merchants_new_url
    assert_response :success
  end

  test "should redirect edit when not logged in" do
    get edit_merchant_path(@merchant)
    assert_not flash.empty?
    assert_redirected_to merchant_login_url
  end

  test "should redirect update when not logged in" do
    patch merchant_path(@merchant), params: { merchant: { company_name: @merchant.company_name,
    email:
    @merchant.email } }
    assert_not flash.empty?
    assert_redirected_to merchant_login_url
  end

  test "should redirect edit when logged in as wrong merchant" do
    merchant_log_in_as(@other_merchant)
    get edit_merchant_path(@merchant)
    assert flash.empty?
    assert_redirected_to root_url
  end
  
  test "should redirect update when logged in as wrong merchant" do
    merchant_log_in_as(@other_merchant)
    patch merchant_path(@merchant), params: { merchant: { company_name: @merchant.company_name,
    email:
    @merchant.email } }
    assert flash.empty?
    assert_redirected_to root_url
  end
end
