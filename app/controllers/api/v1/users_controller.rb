class Api::V1::UsersController < Api::V1::BaseController
    skip_before_action :verify_authenticity_token
    

    # POST /users/:id
    def login
        @user = User.find(params[:id])

    end

    # GET /users
    def index
        @users = User.all
        render json: @users, only: [:name, :address, :email, :contact_no]
    end

    # GET /users/:id
    def show
        @user = User.find(params[:id])
        render json: @user, only: [:name, :address, :email, :contact_no]
        # render jsonapi: user, serializer: Api::V1::UserSerializer
    end

    # POST /users
    def create
        @user = User.new(user_params)
        # puts @user.errors.full_messages
        # puts 'test'
        if @user.save
            @user.send_activation_email
            render json: @user, only: [:name, :address, :email, :contact_no], status: 201
        else
            render json: { status: "error", message: @user.errors.full_messages.join("/n")}, status: 400 
        end

    end

    # user = User.find_by(email: params[:session][:email].downcase)
    # if user && user.authenticate(params[:session][:password])

    # PUT /users/:id
    def update
        @user = User.find(params[:id])
        if @user 
            if @user.authenticate(params[:password])
                if @user.update(user_params)
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

    # DELETE /users/:id
    def destroy
        @user = User.find_by(params[:email])
        if @user
            @user.destroy
            render json: { message: "User successfully deleted." }, status: 204
        else
            render json: { error: "Unable to delete user." }, status: 400
        end
    end

    private
        def user_params
            params.permit(:name, :address, :email, :contact_no, :password, :password_confirmation)
        end


    
end
