require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  test "invalid signup details" do
    get signup_path
    assert_no_difference "User.count" do
      post user_path, user: { name: "", 
                              email: "j-_3_.gmil", 
                              password: "foo", 
                              password_confirmation: "bar", 
                              address: "", 
                              contact_no: "1234" }
    end
    assert_template "users/new"
  end

  test "valid signup details" do
    get signup_path
    assert_difference "User.count", 1 do
      post_via_redirect user_path, user: { name: "YuCin", 
                              email: "yucin@gmail.com", 
                              password: "foobar123", 
                              password_confirmation: "foobar123", 
                              address: "Chai Chee Raod", 
                              contact_no: "12341234" }
    end
    assert_template "users/show"
  end
end
