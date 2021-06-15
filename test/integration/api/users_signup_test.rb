require "test_helper"

class Api::UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    new_user = {
      name: "test user",
      email: "uniqueemail@email.com",
      contact_no: "12341234",
      password: "12341234",
      password_confirmation: "12341234"
    }
  end

  
end
