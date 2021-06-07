class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy]

  def api
    @users = User.all
    render json: @users, formats: [:json]
  end

  def show
    @user = User.find_by(id: params[:id])
    redirect_to root_url and return unless @user and @user.activated?
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    #debugger
    if @user.save
      # log_in @user
      # flash[:success] = "Welcome to DrDelivery!"
      # redirect_to @user
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update 
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def index
    @users = User.where(activated: true).paginate(page: params[:page])
    # @users = User.all
    # render json: @users, formats: [:json]
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end


  private
    def user_params
      params.require(:user).permit(:name, :email, :password, 
        :password_confirmation, :contact_no, :address)
      #debugger
    end

    # Before filters


    # Confirms the correct user
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    # Confirms admin usrs
    def admin_user
      redirect_to root_url unless current_user.admin?
    end


end
