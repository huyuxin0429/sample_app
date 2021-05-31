require "test_helper"



class MerchantsLoginTest < ActionDispatch::IntegrationTest

  def setup
    @merchant = merchants(:michaelinc)
  end

  test "login with invalid information" do
    get merchant_login_path
    assert_template 'merchant_sessions/new'
    post merchant_login_path, params: { sessions: { email: "", password:
    "" } }
    assert_template 'merchant_sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "login with valid information" do
    get merchant_login_path
    post merchant_login_path, params: { session: { email: @merchant.email,
    password: 'password'
    } }
    assert_redirected_to @merchant
    follow_redirect!
    assert_template 'merchants/show'
    assert_select "a[href=?]", merchant_login_path, count: 0
    assert_select "a[href=?]", merchant_logout_path
    assert_select "a[href=?]", merchant_path(@merchant)
  end

  test "login with valid email/invalid password" do
    get merchant_login_path
    assert_template 'merchant_sessions/new'
    post merchant_login_path, params: { session: { email: @merchant.email,
    password: "invalid" }
    }
    assert_not merchant_is_logged_in?
    assert_template 'merchant_sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "login with valid information followed by logout" do
    get merchant_login_path
    post merchant_login_path, params: { session: { email:
    @merchant.email,
    password: 'password'
    } }
    assert merchant_is_logged_in?
    assert_redirected_to @merchant
    follow_redirect!
    assert_template 'merchants/show'
    assert_select "a[href=?]", merchant_login_path, count: 0
    assert_select "a[href=?]", merchant_logout_path
    assert_select "a[href=?]", merchant_path(@merchant)
    delete merchant_logout_path
    assert_not merchant_is_logged_in?
    assert_redirected_to root_url
    # Simulate a user clicking logout in a second window.
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", merchant_login_path
    assert_select "a[href=?]", merchant_logout_path, count: 0
    assert_select "a[href=?]", merchant_path(@merchant), count: 0
    end

    test "login with remembering" do
      merchant_log_in_as(@merchant, remember_me: '1')
      assert_not_nil cookies['merchant_remember_token']
    end

    test "login without remembering" do
      # Log in to set the cookie.
      merchant_log_in_as(@merchant, remember_me: '1')
      # Log in again and verify that the cookie is deleted.
      merchant_log_in_as(@merchant, remember_me: '0')
      assert cookies['merchant_remember_token'], nil || ""
    end
end
