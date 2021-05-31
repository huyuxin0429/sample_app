require "test_helper"

class MerchantsLoginTest < ActionDispatch::IntegrationTest


  # def setup
  #   @merchant = merchants(:michaelinc)
  # end
  # test "login with valid email/invalid password" do
  #   get mlogin_path
  #   assert_template 'm_sessions/new'
  #   post mlogin_path, params: { m_session: { email: "",
  #   password: "invalid" }
  #   }
  #   assert_template 'm_sessions/new'
  #   assert_not flash.empty?
  #   get root_path
  #   assert flash.empty?
  # end

  def setup
    @merchant = merchants(:michaelinc)
  end

  test "login with valid information" do
  get mlogin_path
  post mlogin_path, params: { m_session: { email: @merchant.email,
                                          password: "password"
                                      }}
  assert_redirected_to @merchant
  follow_redirect!
  assert_template 'merchants/show'
  assert_select "a[href=?]", mlogin_path, count: 0
  assert_select "a[href=?]", mlogout_path
  assert_select "a[href=?]", merchant_path(@merchant)
  end

  test "login with invalid information" do
    get mlogin_path
    assert_template 'm_sessions/new'
    post mlogin_path, params: { m_session: { email: "", password: "" } }
    assert_template 'm_sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "login with valid email/invalid password" do
    get mlogin_path
    assert_template 'm_sessions/new'
    post mlogin_path, params: { m_session: { email: "@merchant.email", password: "12341234" } }
    assert_template 'm_sessions/new'
    assert_not mis_logged_in?
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "login with valid information followed by logout" do
    get mlogin_path
    assert_template 'm_sessions/new'
    post mlogin_path, params: { m_session: { email: @merchant.email,
                              password: "password"
                              }}
    assert_redirected_to @merchant
    follow_redirect!
    assert mis_logged_in?
    assert_template 'merchants/show'
    assert_select "a[href=?]", mlogin_path, count: 0
    assert_select "a[href=?]", mlogout_path
    assert_select "a[href=?]", merchant_path(@merchant)
    delete mlogout_path
    assert_not mis_logged_in?
    assert_redirected_to root_path
    follow_redirect!
    assert_select "a[href=?]", mlogin_path
    assert_select "a[href=?]", mlogout_path, count: 0
    assert_select "a[href=?]", merchant_path(@merchant), count: 0
  end

  test "login with valid information on two broswers and log out of both" do
    get mlogin_path
    assert_template 'm_sessions/new'
    post mlogin_path, params: { m_session: { email: @merchant.email,
                              password: "password"
                              }}
    assert_redirected_to @merchant
    follow_redirect!
    assert mis_logged_in?
    assert_template 'merchants/show'
    assert_select "a[href=?]", mlogin_path, count: 0
    assert_select "a[href=?]", mlogout_path
    assert_select "a[href=?]", merchant_path(@merchant)
    delete mlogout_path
    assert_not mis_logged_in?
    assert_redirected_to root_path
    # Simulate merchant logging out of a second window
    delete mlogout_path
    follow_redirect!
    assert_select "a[href=?]", mlogin_path
    assert_select "a[href=?]", mlogout_path, count: 0
    assert_select "a[href=?]", merchant_path(@merchant), count: 0
  end

  # test "login with remembering" do
  #   log_in_as(@merchant, remember_me: "1")
  #   assert_not_nil cookies['mremember_token']
  # end

  # test "login without remembering" do
  #   # First log in to set the cookie
  #   log_in_as(@merchant, remember_me: "1")
  #   # Second log in to check if cookie is deleted
  #   log_in_as(@merchant, remember_me: "0")
  #   assert cookies['mremember_token'], nil || ""

  #   #assert_nil cookies['test']
  # end
end
