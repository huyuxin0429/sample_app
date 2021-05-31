module MerchantSessionsHelper

    # Logs in the given merchant.
    def merchant_log_in(merchant)
        session[:merchant_id] = merchant.id
    end

    # Remembers a merchant in a persistent session.
    def merchant_remember(merchant)
        merchant.remember
        cookies.permanent.encrypted[:merchant_id] = merchant.id
        cookies.permanent[:merchant_remember_token] = merchant.merchant_remember_token
    end

    def merchant_forget(merchant)
        merchant.forget
        # puts(cookies[:user_id])
        # puts(cookies[:remember_token])
        # cookies[:user_id] = nil
        # cookies[:remember_token] = nil
        cookies.delete(:merchant_id)
        cookies.delete(:merchant_remember_token)
        # puts(cookies[:user_id])
        # puts(cookies[:remember_token])
    end

    # Returns the current logged-in merchant (if any).
    def current_merchant
        if (merchant_id = session[:merchant_id])
            @current_merchant ||= Merchant.find_by(id: merchant_id)
            elsif (merchant_id = cookies.encrypted[:merchant_id])
            merchant = Merchant.find_by(id: merchant_id)
            if merchant && merchant.authenticated?(cookies[:merchant_remember_token])
                merchant_log_in merchant
                @current_merchant = merchant
            end
        end
    end

    # Returns true if the merchant is logged in, false otherwise.
    def merchant_logged_in?
        !current_merchant.nil?
    end

    # Logs out the current merchant.
    def merchant_log_out
        session.delete(:merchant_id)
        @current_merchant = nil
    end
end
