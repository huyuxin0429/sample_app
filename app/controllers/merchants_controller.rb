class MerchantsController < ApplicationController
  before_action :logged_in_merchant, only: [:edit, :update]
  before_action :correct_merchant, only: [:edit, :update]

  def index
    @merchants = Merchant.paginate(page: params[:page])
    #@merchants = Merchant.all
  end

  def new
    @merchant = Merchant.new
  end

  def show 
    @merchant = Merchant.find(params[:id])
  end

  def create
    @merchant = Merchant.new(merchant_params)
    if @merchant.save
      merchant_log_in @merchant
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @merchant   
    else
      render 'new'
    end
  end

  def edit
    @merchant = Merchant.find(params[:id])
  end

  def update
    @merchant = Merchant.find(params[:id])
    if @merchant.update(merchant_params)
      flash[:success] = "Profile updated"
      redirect_to @merchant
    else
      render 'edit'
    end
    end

  private
    def merchant_params
      params.require(:merchant).permit(:company_name, :email, :password,
      :password_confirmation, :address, :contact_no)
    end

    # Before filters
    # Confirms a logged-in merchant.
    def logged_in_merchant
      unless merchant_logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to merchant_login_url
      end
    end

    # Confirms the correct merchant.
  def correct_merchant
    @merchant = Merchant.find(params[:id])
    redirect_to(root_url) unless current_merchant?(@merchant)
  end


end
