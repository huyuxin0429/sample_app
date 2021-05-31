require "test_helper"

class MerchantTest < ActiveSupport::TestCase
  def setup
    @merchant = Merchant.new(company_name: "Example Inc", email:
    "merchant@example.com", address: "Chai Chee", contact_no: 12341234,
      password: "foobar", password_confirmation: "foobar")
  end

  test "company name should be present" do
    @merchant.company_name = " "
    assert_not @merchant.valid?
  end

  test "email should be present" do
    @merchant.email = " "
    assert_not @merchant.valid?
  end

  test "name should not be too long" do
    @merchant.company_name = "a" * 51
    assert_not @merchant.valid?
  end

  test "email should not be too long" do
    @merchant.email = "a" * 244 + "@example.com"
    assert_not @merchant.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[merchant@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @merchant.email = valid_address
      assert @merchant.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[merchant@example,com merchant_at_foo.org merchant.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @merchant.email = invalid_address
      assert_not @merchant.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email addresses should be unique" do
    duplicate_merchant = @merchant.dup
    #duplicate_merchant.email = @merchant.email.upcase
    @merchant.save
    assert_not duplicate_merchant.valid?
  end

  test "email address should be saved in lowercase" do
    mixed_case_email = "Foo@ExAmple.com"
    @merchant.email = mixed_case_email
    @merchant.save
    assert_equal mixed_case_email.downcase, @merchant.reload.email
  end

  test "password should be present (nonblank)" do
    @merchant.password = @merchant.password_confirmation = " " * 6
    assert_not @merchant.valid?
  end
  test "password should have a minimum length" do
    @merchant.password = @merchant.password_confirmation = "a" * 5
    assert_not @merchant.valid?
  end
end
