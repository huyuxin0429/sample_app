require "test_helper"

class MerchantsEditTest < ActionDispatch::IntegrationTest
  def setup
    @merchant = merchants(:michaelinc)
  end

  test "unsuccessful edit" do
    mlog_in_as(@merchant)
    get edit_merchant_path(@merchant)
    assert_template "merchants/edit"
    patch merchant_path(@merchant), params: { merchant: { company_name: "Bobinc",
                                              email: "",
                                              password: "",
                                              password_confirmation: "1234",
                                              address: "",
                                              contact_no: "" } }
    # assert_not flash.empty?
    assert_template "merchants/edit"
  end

  # test "successful edit" do
  #   mlog_in_as(@merchant)
  #   get edit_merchant_path(@merchant)
  #   assert_template "merchants/edit"
  #   company_name = "BobTheBuilderInc"
  #   email = "merchantinc@gmail.com"
  #   address = "Chai Chee"
  #   contact_no = 43124312
  #   patch merchant_path(@merchant), params: { merchant: { company_name: company_name,
  #     email: email,
  #     password: "",
  #     password_confirmation: "",
  #     address: address,
  #     contact_no: contact_no } }
  #   # debugger
  #   assert_not flash.empty?
  #   assert_redirected_to @merchant
  #   @merchant.reload
  #   assert_equal company_name, @merchant.company_name
  #   assert_equal email, @merchant.email
  #   assert_equal address, @merchant.address
  #   assert_equal contact_no, @merchant.contact_no
  # end

  # test "successful edit with friendly forwarding" do
  #   get edit_merchant_path(@merchant)
  #   mlog_in_as(@merchant)
  #   assert_redirected_to edit_merchant_path(@merchant)
  #   company_name = "BobTheBuilder"
  #   email = "merchant@gmail.com"
  #   address = "Chai Chee"
  #   contact_no = 43124312
  #   patch merchant_path(@merchant), params: { merchant: { company_name: company_name,
  #     email: email,
  #     password: "",
  #     password_confirmation: "",
  #     address: address,
  #     contact_no: contact_no } }
  #   # debugger
  #   assert_not flash.empty?
  #   assert_redirected_to @merchant
  #   @merchant.reload
  #   assert_equal company_name, @merchant.company_name
  #   assert_equal email, @merchant.email
  #   assert_equal address, @merchant.address
  #   assert_equal contact_no, @merchant.contact_no
  # end
end
