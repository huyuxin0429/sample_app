class Api::V1::SessionsController < Api::V1::BaseController
    # skip_before_action :verify_authenticity_token
    # before_action :logged_in_user_filter, only: [:destroy]
    # def new
    #     # debugger
    # end

    # POST api/v1/sessions
    def create
        # byebug
        user = User.find_by(email: params[:email].downcase)
        if user 
            if user.authenticate(params[:password])
                if user.activated?
                    token = encode_token({user_id: user.id})
                    # log_in user
                    # params[:remember_me] == "1" ? remember(user) : forget(user)
                    # redirect_back_or user
                    render json: { status: "ok", 
                                    message: "Login successful", 
                                    user_id: user.id, 
                                    token: token }, status: 200
                else
                    # message = "Account not activated. "
                    # message += "Check your email for the activation link"
                    render json: { status: "error", message: "User not activated" }, status: 403
                    # flash[:warning] = message
                    # redirect_to root_url
                end
            else
                render json: { status: "error", message: "User not authenticated" }, status: 403
            end
        else
            # flash.now[:danger] = 'Invalid email/password combination'
            # render 'new'
            render json: { status: "error", message: "User not found" }, status: 401
        end
    end
    
    def auto_login
        render json: @user
    end

    def destroy
        current_user = nil
        #user = sessions[:user_id]
        # log_out if logged_in? #current_user
        # redirect_to root_url
        render json: { status: "ok", message: "Logged out" }, status: 205
    end

    def log_in(user)
        session[:user_id] = user.id
    end 

   
end
