class Api::V1::UsersController < Api::V1::BaseController
    # skip_before_action :verify_authenticity_token
    

    # GET /users
    def index
        @users = User.all
        render json: @users, only: [:id, :name, :email, :contact_no]
    end

    # GET /users/:id
    def show
        @user = User.find(params[:id])
        render json: @user, only: [:name, :email, :contact_no]
        # render json: @user
    end

    # POST /users
    def create
        # byebug

        @user = User.new(user_params)
        # puts @user.errors.full_messages
        # puts 'test'
        if @user.save
            @user.send_activation_email
            render json: @user, only: [:name, :email, :contact_no], status: 201
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
        @user = User.find(params[:id])
        if @user
            @user.destroy
            render json: { message: "User successfully deleted." }, status: 204
        else
            render json: { error: "User does not exist." }, status: 400
        end
    end

    private
        def user_params
            params.require(:user).permit(:name, :email, :contact_no, :password, :password_confirmation)
        end


end
