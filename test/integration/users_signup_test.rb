require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  test "invalid signup details" do
    get signup_path
    assert_no_difference "User.count" do
      post users_path, params: { user: { name: "", 
                              email: "j-_3_.gmil", 
                              password: "foo", 
                              password_confirmation: "bar", 
                              address: "", 
                              contact_no: "1234" }}
    end
    assert_template "users/new"
    # assert_select 'div#<CSS id for error explanation>'
    # assert_select 'div.<CSS class for field with error>'
  end

  test "valid signup details" do
    get signup_path
    assert_difference "User.count", 1 do
      post users_path, params: { user: { name: "YuCin", 
                              email: "yucin@gmail.com", 
                              password: "foobar123", 
                              password_confirmation: "foobar123", 
                              address: "Chai Chee Raod", 
                              contact_no: "12341234" }}
      
    end
    follow_redirect!
    # assert_template "users/show"
    # assert_not flash.empty?
    # assert is_logged_in?
  end

end
