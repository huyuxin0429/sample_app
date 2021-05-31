require 'test_helper'

class MerchantSessionsHelperTest < ActionView::TestCase
    def setup
        @merchant = merchants(:michaelinc)
        merchant_remember(@merchant)
    end

    test "current_merchant returns right merchant when session is nil" do
        assert_equal @merchant, current_merchant
        assert merchant_is_logged_in?
    end

    test "current_merchant returns nil when remember digest is wrong" do
        @merchant.update_attribute(:merchant_remember_digest, 
            User.digest(User.new_token))
        assert_nil current_merchant
    end
end