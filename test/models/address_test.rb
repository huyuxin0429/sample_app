require "test_helper"

class AddressTest < ActiveSupport::TestCase
  def setup
  @address = Address.new(
    street_address: "Chai Chee Road",
    city: "Singapore",
    country: "Singapore",
    postal_code: "123412",
    building_no: "23",
    unit_number: "#23-323",
    name: "Home"
  )
  end

  test "should be valid" do
    assert @address.valid?
  end

  test "missing street_address should be invalid" do
    @address.street_address = nil
    assert_not @address.valid?
  end
end
