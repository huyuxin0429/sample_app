class Api::V1::AddressesController < Api::V1::BaseController
    # skip_before_action :verify_authenticity_token
    before_action :logged_in_user_filter, only: [:create, :destroy, :index, :show]
    before_action :correct_user_filter, only: [:destroy, :index, :create, :show]
    # before_action :admin_user_filter, only: [:destroy, :index, :create, :show]
    def new
        
    end

    def stated_user
        if params.key?(:customer_id)
            user_id_name = :customer_id
        elsif params.key?(:merchant_id)
            user_id_name = :merchant_id
        end

        User.find(params[user_id_name])
    end

    

    # POST /api/v1/users/:id/addresses
    def create
        # @user = Users.find(params[:user_id])
        @address = stated_user.addresses.build(address_params)
        # byebug
        street_address = address_params["street_address"]
        city = address_params["city"]
        country = address_params["country"]
        postal_code = address_params["postal_code"]
        building_number = address_params["building_number"]
        unit_number = address_params["unit_number"]

        search_data =  
            [street_address, 
            city, 
            country, 
            postal_code, 
            building_number,
            unit_number
            ].compact.join(', ')
        
        result = Geocoder.search(search_data).first
        if result.nil?
            render json: {status: "error", message: "Invalid address"}, status: 401
            return
        end
        result = result.coordinates
        @address.latitude = result[0]
        @address.longitude = result[1]
        # @address.user_type = address_paI rams["user_type"]

        if @address.save
            render json: { message: "Address created"}, status: 201
        else
            render json: { status: "error", 
                message: @address.errors.full_messages }, 
                status: 401
        end
    end

    # GET /api/v1/users/:id/addresses
    def index
        # byebug
        # @user = User.find(params[:user_id])
        # byebug
        @addresses = stated_user.addresses.all;
        
        render json: @addresses
    end


    # PUT api/v1/users/:user_id/addresses/:id
    def update
        # @user = User.find(params[:user_id])
        if stated_user.addresses && 
            @address = stated_user.addresses.find_by(id: params[:id])
            oldAddress = @address.deep_copy

            street_address = address_params["street_address"]
            city = address_params["city"]
            country = address_params["country"]
            postal_code = address_params["postal_code"]
            building_number = address_params["building_number"]
            unit_number = address_params["unit_number"]

            search_data =  
                [street_address, 
                city, 
                country, 
                postal_code, 
                building_number,
                unit_number
                ].compact.join(', ')
            result = Geocoder.search(search_data).first
            if result.nil?
                render json: {status: "error", message: "Invalid address"}, status: 401

            elsif @address.update(address_params)
                    render json: { message: "Address successfully updated" }, status: 200
                # byebug
            else
                render json: { status: "error", message: @address.errors.full_messages}, status: 400 
            end
        else
            render json: { error: "Address not found" }, status: 400
        end
    end


    # GET /api/v1/users/:id/addresses/:address_id
    def show
        # @user = User.find(params[:user_id])
        @address = stated_user.addresses.find_by(id: params[:id])
        if @address
            render json: @address
        else
            render json: { error: "Address does not exist." }, status: 400
        end
        
    end

    # DELETE /api/v1/users/:id/addresses/:address_id
    def destroy
        # @user = User.find(params[:user_id])
        if current_user.addresses && 
            @address = stated_user.addresses.find_by(id: params[:id])
            
            if @address.addressable_type == "User"
                orders = Order.where(pick_up_address_id: @address.id).reload
                orders.each { |order|
                    copy = @address.deep_copy
                    copy.addressable_type = "Order"
                    copy.addressable_id = order.id
                    copy.addressable = order
                    copy.save!
                    order.pick_up_address_id = copy.id
                    order.save!
                
                }
                orders = Order.where(drop_off_address_id: @address.id).reload
                orders.each { |order|
                    copy = @address.deep_copy
                    copy.addressable_type = "Order"
                    copy.addressable_id = order.id
                    copy.addressable = order
                    copy.save!
                    order.drop_off_address_id = copy.id
                    order.save!
                
                }
                # byebug
            end
            # byebug
            @address.destroy
            render json: { message: "Address destroyed"}, status: 204
        else
            render json: { error: "Address does not exist." }, status: 400
        end
 
      
    end

    private
        def address_params
            params.permit(
                :street_address,
                :city,
                :country,
                :postal_code,
                :building_number,
                :unit_number,
                :name
                )
        end

        def correct_user_filter
            # byebug
            
            if params.has_key?(:customer_id)
                @user = Customer.find(params[:customer_id])
            elsif params.has_key?(:merchant_id)
                @user = Merchant.find(params[:merchant_id])
            end
            
            render json: { message: 'Unauthorised user' },
                status: :unauthorized unless current_user?(stated_user) || current_user.admin?
        end


end
