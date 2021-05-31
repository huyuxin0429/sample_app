module MSessionsHelper
    #Logs in given merchant
    def mlog_in(merchant)
        session[:merchant_id] = merchant.id
    end 

    # Returns the current Logged-in merchant (if any)
    def current_merchant
        #@current_merchant ||= Merchant.find_by(id: session[:merchant_id])
        if (merchant_id = session[:merchant_id])
            @current_merchant ||= Merchant.find_by(id: merchant_id)
        elsif (merchant_id = cookies.encrypted[:merchant_id])
            # raise
            merchant = Merchant.find_by(id: merchant_id)
            if (merchant && merchant.authenticated?(cookies[:remember_token]))
                log_in merchant
                @current_merchant = merchant
            end
        end
    end

    # Returns true if the merchant is logged in, false otherwise.
    def mlogged_in?
        !current_merchant.nil?
    end

    def mlog_out
        mforget(current_merchant)
        session.delete(:merchant_id)
        @current_merchant = nil
    end

    def mremember(merchant)
        merchant.remember
        cookies.permanent.encrypted[:merchant_id] = merchant.id
        cookies.permanent[:mremember_token] = merchant.remember_token
    end

    def mforget(merchant)
        merchant.forget
        # puts(cookies[:merchant_id])
        # puts(cookies[:remember_token])
        # cookies[:merchant_id] = nil
        # cookies[:remember_token] = nil
        cookies.delete(:merchant_id)
        cookies.delete(:mremember_token)
        # puts(cookies[:merchant_id])
        # puts(cookies[:remember_token])
    end

    # Returns true if the given merchant is the current merchant
    def mcurrent_merchant?(merchant)
        merchant && merchant == current_merchant
    end

    # Redirects to stored location (or to the default)
    def redirect_back_or(default)
        redirect_to(session[:mforwarding_url] || default)
        session.delete(:mforwarding_url)
    end

    # Stores the URL trying to be accessed.
    def store_location
        session[:mforwarding_url] = request.original_url if request.get?
    end
end
