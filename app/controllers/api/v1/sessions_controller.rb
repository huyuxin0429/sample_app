class Api::V1::SessionsController < Api::V1::BaseController
    skip_before_action :verify_authenticity_token

    def new
        # debugger
    end

    # POST api/v1/login
    def create
        user = User.find_by(email: params[:email].downcase)
        if user 
            if user.authenticate(params[:password])
                if user.activated?
                    log_in user
                    params[:remember_me] == "1" ? remember(user) : forget(user)
                    # redirect_back_or user
                    render json: { status: "ok", message: "Login successful" }, status: 200
                else
                    # message = "Account not activated. "
                    # message += "Check your email for the activation link"
                    render json: { status: "error", message: "User not activated" }, status: 401
                    # flash[:warning] = message
                    # redirect_to root_url
                end
            else
                render json: { status: "error", message: "User not authenticated" }, status: 401
            end
        else
            # flash.now[:danger] = 'Invalid email/password combination'
            # render 'new'
            render json: { status: "error", message: "User not found" }, status: 401
        end
    end

    def destroy
        #user = sessions[:user_id]
        log_out if logged_in? #current_user
        redirect_to root_url
    end

    def log_in(user)
        session[:user_id] = user.id
    end 

    # Returns the current Logged-in user (if any)
    def current_user
        #@current_user ||= User.find_by(id: session[:user_id])
        if (user_id = session[:user_id])
            @current_user ||= User.find_by(id: user_id)
        elsif (user_id = cookies.encrypted[:user_id])
            # raise
            user = User.find_by(id: user_id)
            if (user && user.authenticated?(:remember, cookies[:remember_token]))
                log_in user
                @current_user = user
            end
        end
    end

    # Returns true if the user is logged in, false otherwise.
    def logged_in?
        !current_user.nil?
    end

    def log_out
        forget(current_user)
        session.delete(:user_id)
        @current_user = nil
    end

    def remember(user)
        user.remember
        cookies.permanent.encrypted[:user_id] = user.id
        cookies.permanent[:remember_token] = user.remember_token
    end

    def forget(user)
        user.forget
        # puts(cookies[:user_id])
        # puts(cookies[:remember_token])
        # cookies[:user_id] = nil
        # cookies[:remember_token] = nil
        cookies.delete(:user_id)
        cookies.delete(:remember_token)
        # puts(cookies[:user_id])
        # puts(cookies[:remember_token])
    end

    # Returns true if the given user is the current user
    def current_user?(user)
        user && user == current_user
    end

    # Redirects to stored location (or to the default)
    def redirect_back_or(default)
        redirect_to(session[:forwarding_url] || default)
        session.delete(:forwarding_url)
    end

    # Stores the URL trying to be accessed.
    def store_location
        session[:forwarding_url] = request.original_url if request.get?
    end
end
