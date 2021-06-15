require "test_helper"

class Api::UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
      name: "test user",
      email: "uniqueemail@email.com",
      contact_no: "12341234",
      password: "12341234",
      password_confirmation: "12341234"
  end

  test "default sign up information should be accepted" do
    post "/users, params:
      name: 
  end


end
