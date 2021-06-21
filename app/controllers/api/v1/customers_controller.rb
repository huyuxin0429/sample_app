class Api::V1::CustomersController <  Api::V1::UsersController

    def identifiable_user_in_params
        Customer.find(params[:id])
    end


end
