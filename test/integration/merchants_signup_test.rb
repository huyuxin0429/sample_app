require "test_helper"

class MerchantsSignupTest < ActionDispatch::IntegrationTest
  test "invalid signup details" do
    get msignup_path
    assert_no_difference "Merchant.count" do
      post merchants_path, params: { merchant: { company_name: "", 
                              email: "j-_3_.gmil", 
                              password: "foo", 
                              password_confirmation: "bar", 
                              address: "", 
                              contact_no: "1234" }}
    end
    assert_template "merchants/new"
    # assert_select 'div#<CSS id for error explanation>'
    # assert_select 'div.<CSS class for field with error>'
  end

  test "valid signup details" do
    get msignup_path
    assert_difference "Merchant.count", 1 do
      post merchants_path, params: { merchant: { company_name: "YuCin.Co", 
                              email: "yucinCompany@gmail.com", 
                              password: "foobar123", 
                              password_confirmation: "foobar123", 
                              address: "Chai Chee Raod", 
                              contact_no: "12341234" }}
      
    end
    follow_redirect!
    assert_template "merchants/show"
    assert_not flash.empty?
    assert mis_logged_in?
  end
end
