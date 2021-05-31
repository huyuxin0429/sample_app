require "test_helper"

class MerchantsEditTest < ActionDispatch::IntegrationTest
  def setup
    @merchant = merchants(:michaelinc)
  end

  test "unsuccessful edit" do
    merchant_log_in_as(@merchant)
    get edit_merchant_path(@merchant)
    assert_template 'merchants/edit'
    patch merchant_path(@merchant), params: { merchant: { company_name: "",
    email:
    "foo@invalid",
    password:
    "foo",
    password_confirmation: "bar" } }
    assert_template 'merchants/edit'
  end

  test "successful edit" do
    merchant_log_in_as(@merchant)
    get edit_merchant_path(@merchant)
    assert_template 'merchants/edit'
    company_name = "Foo Bar"
    email = "foo@bar.com"
    patch merchant_path(@merchant), params: { merchant: { company_name: company_name,
    email: email,
    password:
    "",
    password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @merchant
    @merchant.reload
    assert_equal company_name, @merchant.company_name
    assert_equal email, @merchant.email
  end

  test "successful edit with friendly forwarding" do
    get edit_merchant_path(@merchant)
    merchant_log_in_as(@merchant)
    assert_redirected_to edit_merchant_path(@merchant)
    company_name = "Foo Bar"
    email = "foo@bar.com"
    patch merchant_path(@merchant), params: { merchant: { company_name: company_name,
    email: email,
    password:
    "",
    password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @merchant
    @merchant.reload
    assert_equal company_name, @merchant.company_name
    assert_equal email, @merchant.email
  end
end
