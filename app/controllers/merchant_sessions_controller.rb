class MerchantSessionsController < ApplicationController
  def new
  end

  def create
      merchant = Merchant.find_by(email: params[:session][:email].downcase)
      if merchant && merchant.authenticate(params[:session][:password])
      # Log the merchant in and redirect to the merchant's show page.
      merchant_log_in merchant
      params[:session][:remember_me] == '1' ? merchant_remember(merchant) : merchant_forget(merchant)
      # merchant_remember merchant
      redirect_to merchant
      else
      # Create an error message.
        flash.now[:danger] = 'Invalid email/password combination'
        render 'new'
      end
  end

  def destroy
    merchant_log_out if merchant_logged_in?
    redirect_to root_url
  end

end
