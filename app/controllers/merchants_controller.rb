class MerchantsController < ApplicationController
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
      log_in @merchant
      flash[:success] = "Welcome to DrDelivery!"
      redirect_to @merchant
    else
      render 'new'
    end
    debugger
  end

  private
    def merchant_params
      params.require(:merchant).permit(:company_name, :email, :password, 
        :password_confirmation, :contact_no, :address)
      #debugger
    end
end
