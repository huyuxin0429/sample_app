class Api::V1::AddressesController < Api::V1::BaseController
    # skip_before_action :verify_authenticity_token
    before_action :logged_in_user, only: [:create, :destroy]
    before_action :correct_user, only: :destroy
    def new
        
    end

    # POST /api/v1/users/:id/addresses
    def create
        # @user = Users.find(params[:user_id])
        current_user
        @address = current_user.addresses.build(address_params)
        if @address.save
            render json: { message: "Address created"}, status: 201
        else
            render json: { status: "error", 
                message: @address.errors.full_messages.join("/n") }, 
                status: 401
        end
    end

    # GET /api/v1/users/:id/addresses
    def index
        # byebug
        # @user = User.find(params[:user_id])
        @addresses = current_user.addresses.all;
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


    # PUT api/v1/users/:user_id/addresses/:id
    def update
        # @user = User.find(params[:user_id])
        if current_user.addresses && 
            @address = current_user.addresses.find_by(id: params[:id])
            if @address.update(address_params)
                render json: { message: "Address successfully updated" }, status: 200
            else
                render json: { status: "error", message: @address.errors.full_messages.join("/n")}, status: 400 
            end
        else
            render json: { error: "Address not found" }, status: 400
        end
    end

    # GET /api/v1/users/:id/addresses/:address_id
    def show
        # @user = User.find(params[:user_id])
        @address = current_user.addresses.find_by(id: params[:id])
        if @address
            render json: @address, only: [
                :street_address,
                :city,
                :country,
                :postcode,
                :building_no,
                :unit_number,
                :name
            ]
        else
            render json: { error: "Address does not exist." }, status: 400
        end
        
    end

    # DELETE /api/v1/users/:id/addresses/:address_id
    def destroy
        # @user = User.find(params[:user_id])
        if current_user.addresses && 
            @address = current_user.addresses.find_by(id: params[:id])
            @address.destroy
            render json: { message: "Address destroyed"}, status: 204
        else
            render json: { error: "Address does not exist." }, status: 400
        end
 
      
    end

    private
        def address_params
            params.require(:address).permit(
                :street_address,
                :city,
                :country,
                :postcode,
                :building_no,
                :unit_number,
                :name)
        end

        # Before filters
        def correct_user
            @address = current_user.addresses.find_by(id: params[:id])
            redirect_to root_url if @address.nil?
        end
end
