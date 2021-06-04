require "test_helper"

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:michael)
    @non_admin = users(:archer)
    @another_non_admin = users(:lana)
  end

  test "index including pagination" do
    #debugger
    log_in_as(@non_admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    User.paginate(page: 1).each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
    end
  end

  test "index as admin including pagination and delete links" do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      unless user == @admin
        assert_select 'a[href=?]', user_path(user), text: 'delete'
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end

  test "index as non-admin" do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end

  test "index should not include non-activated users" do
    post users_path, params: { user: { name: "Example User",
      email: "user@example.com",
      password: "password",
      password_confirmation: "password",
      contact_no: "12341234",
      address: "Chai Chee" }} 
    user = assigns(:user)
    assert_not user.activated?

    log_in_as(@non_admin)
    get users_path
    assert_template 'users/index'
    assert_select 'a[href=?]', user_path(user), text: user.name, count: 0
  end
end
