module MerchantSessionsHelper

    # Logs in the given merchant.
    def merchant_log_in(merchant)
        session[:merchant_id] = merchant.id
    end

    # Returns the current logged-in merchant (if any).
    def current_merchant
        if session[:merchant_id]
            @current_merchant ||= Merchant.find_by(id: session[:merchant_id])
        end
    end

    # Returns true if the user is logged in, false otherwise.
    def merchant_logged_in?
        !current_merchant.nil?
    end

    # Logs out the current user.
    def merchant_log_out
        session.delete(:merchant_id)
        @current_merchant = nil
    end
end
