class Api::V1::MerchantsController < Api::V1::UsersController
    def identifiable_user_in_params
        Merchant.find(params[:id])
    end

    def showAllMerchantAddresses
        @merchants = Merchant.all
        @addresses = @merchants.flat_map{ |merchant| merchant.addresses if merchant.addresses.size > 0 }
        @addresses = @addresses.select{ |merchant| not merchant.nil?}
        render json: @addresses, only: [
            :id,
            :street_address,
            :city,
            :country,
            :postcode,
            :building_no,
            :unit_number,
            :name
        ]
    end
end
