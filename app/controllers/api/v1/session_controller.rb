class Api::V1::SessionController < Api::V1::BaseController
    def new
        # debugger
    end

    def create
    user = User.find_by(email: params[:email].downcase)
    if user && user.authenticate(params[:password])
        if user.activated?
        log_in user
        params[:remember_me] == "1" ? remember(user) : forget(user)
        # redirect_back_or user
        render :json
        else
        message = "Account not activated. "
        message += "Check your email for the activation link"
        # flash[:warning] = message
        # redirect_to root_url

        end
    else
        flash.now[:danger] = 'Invalid email/password combination'
        render 'new'
    end
    end

    def destroy
        #user = sessions[:user_id]
        log_out if logged_in? #current_user
        redirect_to root_url
    end
end
