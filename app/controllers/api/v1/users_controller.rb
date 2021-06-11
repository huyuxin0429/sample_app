class Api::V1::UsersController < ApplicationController
    skip_before_action :verify_authenticity_token
    
    def index
        @users = User.all
        render json: @users, only: [:name, :address, :email, :contact_no]
    end

    def show
        @user = User.find(params[:id])
        render json: @user, only: [:name, :address, :email, :contact_no]
    end

    def create
        @user = User.new(user_params)
        if @user.save
            render json: @user, only: [:name, :address, :email, :contact_no]
        else
            render error: { error: @user.errors.full_messages }, status: 400
        end

    end

    def update
        @user = User.find(params[:id])
        if @user
            @user.update(user_params)
            render json: { message: "User successfully updated" }, status: 200
        else
            render error: { error: @user.errors.full_messages }, status: 400
        end
    end

    def destroy
        @user = User.find(params[:id])
        if @user
            @user.destroy
            render json: { message: "User successfully deleted." }, status: 200
        else
            render json: { error: "Unable to delete user." }, status: 400
        end
    end

    private
        def user_params
            params.require(:user).permit(:name, :address, :email, :contact_no)
        end

    
end
