class MSessionsController < ApplicationController
  include MSessionsHelper
  def new
  end

  def create 
    merchant = Merchant.find_by(email: params[:m_session][:email].downcase)
    if merchant && merchant.authenticate(params[:m_session][:password])
      mlog_in merchant
      params[:m_session][:remember_me] == "1" ? remember(merchant) : forget(merchant)
      redirect_back_or merchant
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    #user = sessions[:user_id]
    mlog_out if mlogged_in? #current_user
    redirect_to root_url
end
end
