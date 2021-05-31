ENV['RAILS_ENV'] ||= 'test'
require_relative "../config/environment"
require "rails/test_help"
require "minitest/reporters"
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  # parallelize(workers: :number_of_processors, with: :threads)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  include ApplicationHelper

  # Add more helper methods to be used by all tests here...

  # Returns true if a test user is logged in.
  def is_logged_in?
    !session[:user_id].nil?
  end

  # Log in as a particular user
  def log_in_as(user)
    session[:user_id] = user.id
  end

  def mis_logged_in?
    !session[:merchant_id].nil?
  end

  # Log in as a particular user
  def mlog_in_as(merchant)
    session[:merchant_id] = merchant.id
  end
end

class ActionDispatch::IntegrationTest

  # Log in as a particular user
  def log_in_as(user, password: "password", remember_me: "1")
    post login_path, params: { session: { email: user.email,
                                          password: password,
                                          remember_me: remember_me } }
  end

  def mlog_in_as(merchant, password: "password", remember_me: "1")
    post mlogin_path, params: { m_session: { email: merchant.email,
                                          password: password,
                                          remember_me: remember_me } }
  end
end
