class Api::V1::AccountActivationsController < Api::V1::BaseController
    def edit
        user = User.find_by(email: params[:email])
        if user && !user.activated? && user.authenticated?(:activation, 
                                            params[:id])
            user.activate
            # log_in user
            # flash[:success] = "Account activated!"
            # redirect_to user
            render json: { status: "saved", message: "account activated"}, status: 200
        else

            # flash[:danger] = "Invalid activation link"
            # redirect_to root_url
            render json: { status: "error", message: "invalid activation link"}, status: 403
        end
    end
end
