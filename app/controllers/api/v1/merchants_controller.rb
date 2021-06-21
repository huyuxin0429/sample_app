class Api::V1::MerchantsController < Api::V1::UsersController
    def identifiable_user_in_params
        Merchant.find(params[:id])
    end
end
