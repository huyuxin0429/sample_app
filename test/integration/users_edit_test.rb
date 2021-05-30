require "test_helper"

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template "users/edit"
    patch user_path(@user), params: { user: { name: "BobTheBuilder",
                                              email: "",
                                              password: "",
                                              password_confirmation: "1234",
                                              address: "",
                                              contact_no: "" } }
    # assert_not flash.empty?
    assert_template "users/edit"
  end

  test "successful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template "users/edit"
    name = "BobTheBuilder"
    email = "user@gmail.com"
    address = "Chai Chee"
    contact_no = 43124312
    patch user_path(@user), params: { user: { name: name,
      email: email,
      password: "",
      password_confirmation: "",
      address: address,
      contact_no: contact_no } }
    # debugger
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
    assert_equal address, @user.address
    assert_equal contact_no, @user.contact_no
  end

  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    name = "BobTheBuilder"
    email = "user@gmail.com"
    address = "Chai Chee"
    contact_no = 43124312
    patch user_path(@user), params: { user: { name: name,
      email: email,
      password: "",
      password_confirmation: "",
      address: address,
      contact_no: contact_no } }
    # debugger
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
    assert_equal address, @user.address
    assert_equal contact_no, @user.contact_no
  end
end