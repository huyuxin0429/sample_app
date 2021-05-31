class MerchantsController < ApplicationController
  def new
    @merchant = Merchant.new
  end

  def show 
    @merchant = Merchant.find(params[:id])
  end

  def create
    @merchant = Merchant.new(merchant_params)
    if @merchant.save
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @merchant   
    else
      render 'new'
    end
  end

  private
    def merchant_params
      params.require(:merchant).permit(:company_name, :email, :password,
      :password_confirmation, :address, :contact_no)
    end
end
