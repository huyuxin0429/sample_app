class MerchantsController < ApplicationController
  include MSessionsHelper
  def new
    @merchant = Merchant.new
  end

  def show
    @merchant = Merchant.find(params[:id])
  end

  def create
    @merchant = Merchant.new(merchant_params)
    #debugger
    if @merchant.save
      mlog_in @merchant
      flash[:success] = "Welcome to DrDelivery!"
      redirect_to @merchant
    else
      render 'new'
    end
    #debugger
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

  def index
    @merchants = Merchant.order(:id).paginate(page: params[:page])
  end

  def destroy
    Merchant.find(params[:id]).destroy
    flash[:success] = "Merchant deleted"
    redirect_to merchants_url
  end

  private
    def merchant_params
      params.require(:merchant).permit(:company_name, :email, :password, 
        :password_confirmation, :contact_no, :address)
      #debugger
    end

    # Confirms a logged-in merchant
    def logged_in_merchant
      unless logged_in?
        store_location
        flash[:danger] = "Please log in"
        redirect_to login_url
      end
    end

    # Confirms the correct merchant
    def correct_merchant
      @merchant = Merchant.find(params[:id])
      redirect_to(root_url) unless current_merchant?(@merchant)
    end

end
