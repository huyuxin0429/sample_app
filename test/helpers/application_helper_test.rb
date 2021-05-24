require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
    test "full title test" do
        assert_equal full_title, "DrDelivery"
        assert_equal full_title("Help"), "Help | DrDelivery"
        assert_equal full_title("About"), "About | DrDelivery"
        assert_equal full_title("Contact"), "Contact | DrDelivery"
        assert_equal full_title("Sign Up"), "Sign Up | DrDelivery"

    end
end