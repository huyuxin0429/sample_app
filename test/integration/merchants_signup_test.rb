require "test_helper"

class MerchantsSignupTest < ActionDispatch::IntegrationTest
  test "invalid signup information" do
    get merchant_signup_path
    assert_no_difference 'Merchant.count' do
    post merchants_path, params: { merchant: { company_name: "",
      email: "merchant@invalid",
      password:
      "foo",
      password_confirmation:
      "bar" } }
    end
      assert_template 'merchants/new'
    end

    test "valid signup information" do
      get merchant_signup_path
      assert_difference 'Merchant.count', 1 do
      post merchants_path, params: { merchant: { company_name: "Example Inc",
        email: "company_inc@example.com",
        password:
        "password",
        password_confirmation:
        "password",
        address: "hahaha",
        contact_no: 12341234 } }
      end
        follow_redirect!
        assert_template 'merchants/show'
        assert merchant_is_logged_in?
      end
end
