require "test_helper"

class UserIdTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    @admin = users(:michael)
    @non_admin = users(:archer)
  end

  test "non activated users should be redirected to root" do
    post users_path, params: { user: { name: "Example User",
      email: "fakeuser@example.com",
      password: "password1234",
      password_confirmation: "password1234",
      contact_number: "12341234",
      address: "Chai Chee" }} 
    user = assigns(:user)
    assert_not user.activated?

    get user_path(user)
  
    assert_redirected_to root_path
  end

  # No idea how to test as of now
  # test "non existant users should be redirected to root" do
  #   user: { name: "Example User",
  #     email: "fakeuser@example.com",
  #     password: "password1234",
  #     password_confirmation: "password1234",
  #     contact_number: "12341234",
  #     address: "Chai Chee" }
  #   get user_path(user)
  #   assert_redirected_to root_path
  # end
end
