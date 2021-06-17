class Api::V1::UsersController < Api::V1::BaseController
    # skip_before_action :verify_authenticity_token
    before_action :logged_in_user_filter, only: [:show]
    before_action :correct_user_filter, only: [:show, :update, :destroy]
    before_action :admin_user_filter, only: [:index ]

    # GET /api/v1/users
    def index
        @users = User.all
        render json: @users #, only: [:id, :name, :email, :contact_no]
    end

    # GET /api/v1/customers
    def indexCustomer
        @users = User.where(role: "customer")
        render json: @users
    end
    # GET /api/v1/merchants
    def indexMerchant
        @users = User.where(role: "merchant")
        render json: @users
    end



    # GET /api/v1/users/:id
    def show
        @user = User.find(params[:id])
        render json: @user #, only: [:id, :name, :email, :contact_no]
        # render json: @user
    end

    # POST /api/v1/users
    def create
        # byebug

        @user = User.new(create_user_params)
        # puts @user.errors.full_messages
        # puts 'test'
        if @user.save
            @user.send_activation_email
            token = encode_token({user_id: @user.id})
            render json: { status: "saved", user: @user, token: token }
            # render json: @user, only: [:id, :name, :email, :contact_no], status: 201
        else
            render json: { status: "error", message: @user.errors.full_messages.join("/n")}, status: 400 
        end

    end

    # user = User.find_by(email: params[:session][:email].downcase)
    # if user && user.authenticate(params[:session][:password])

    # PUT /api/v1/users/:id
    def update
        @user = User.find(params[:id])
        if @user 
            if @user.authenticate(params[:password])
                if @user.update(update_user_params)
                    render json: { message: "User successfully updated" }, status: 200
                else
                    render json: { status: "error", message: @user.errors.full_messages.join("/n")}, status: 400 
                end
            else
                render json: { error: "User not authenticated" }, status: 400
            end
        else
            render json: { error: "User not found" }, status: 400
        end
    end

    # DELETE /api/v1/users/:id
    def destroy
        @user = User.find(params[:id])
        if @user
            @user.destroy
            render json: { message: "User successfully deleted." }, status: 204
        else
            render json: { error: "User does not exist." }, status: 400
        end
    end

    private
        def create_user_params
            params.require(:user).permit(
                :name, 
                :email, 
                :contact_no, 
                :password, 
                :password_confirmation,
                :role)
        end

        def update_user_params
            params.require(:user).permit(
                :name, 
                :email, 
                :contact_no, 
                :password, 
                :password_confirmation
                )
        end

        # Before filters
        def correct_user_filter
            # byebug
            @user = User.find(params[:id])
            
            render json: { message: 'Unauthorised user' },
                status: :unauthorized unless current_user?(@user) || current_user.admin?
        end

        def admin_user
            render json: { message: 'Unauthorised user' }, 
                status: :unauthorized unless current_user && current_user.admin?
        end

        # def logged_in_user
        #     render json: { message: 'Please log in' }, status: :unauthorized unless logged_in?
        # end
        # end
    # end
end
