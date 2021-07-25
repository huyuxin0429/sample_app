class Api::V1::UsersController < Api::V1::BaseController
    # skip_before_action :verify_authenticity_token
    before_action :logged_in_user_filter, only: [:show]
    before_action :correct_user_filter, only: [:show, :update, :destroy]
    before_action :admin_user_filter, only: [:index ]

    

    # GET /api/v1/users
    def index
        # instance_variable = instance_variable_get("@#{controller_name.singularize}")
        instance_variable = instance_variable_get("@#{controller_name.pluralize}")
        class_variable = controller_name.classify.constantize
        instance_variables = class_variable.all
        render json: instance_variables, include:
                [:addresses =>{ :only =>  [
                    :id,
                    :street_address,
                    :city,
                    :country,
                    :postal_code,
                    :building_number,
                    :unit_number,
                    :name
                ] } ]
         #, only: [:id, :name, :email, :contact_number]
    end

    # GET /api/v1/customers
    # def indexCustomer
    #     @users = User.where(role: "customer")
    #     render json: @users
    # end
    # # GET /api/v1/merchants
    # def indexMerchant
    #     @users = User.where(role: "merchant")
    #     render json: @users, include:
    #         [:addresses =>{ :only =>  [
    #             :id,
    #             :street_address,
    #             :city,
    #             :country,
    #             :postal_code,
    #             :building_number,
    #             :unit_number,
    #             :name
    #         ] } ]
    # end

    


    # GET /api/v1/users/:id

    


    def show
        instance_variable = instance_variable_get("@#{controller_name.pluralize}")
        class_variable = controller_name.classify.constantize
        instance_variable = class_variable.find_by(id: params[:id])
        # @user = User.find(params[:id])
        # render json: @user #, only: [:id, :name, :email, :contact_number]
        
        # if params.keys.fourth == :
        if instance_variable
            render json: instance_variable #, only: [:id, :name, :email, :contact_number]
        else
            render json: { error: "User does not exist." }, status: 400
        end

    end

    # def showCustomer
    #     @user = User.where(role: "customer").find_by(id: params[:id])
    #      #, only: [:id, :name, :email, :contact_number]
    #     # render json: @user
    #     if @user
    #         render json: @user, include:
    #         [:addresses =>{ :only =>  [
    #             :id,
    #             :street_address,
    #             :city,
    #             :country,
    #             :postal_code,
    #             :building_number,
    #             :unit_number,
    #             :name
    #         ] } ]
    #     else
    #         render json: { status: "error", message: "Customer not found" }, status: 400 
    #     end
    # end

    # def showMerchant
    #     @user = User.where(role: "merchant").find_by(id: params[:id])
    #      #, only: [:id, :name, :email, :contact_number]
    #     # render json: @user
    #     if @user
    #         render json: @user, include:
    #         [:addresses =>{ :only =>  [
    #             :id,
    #             :street_address,
    #             :city,
    #             :country,
    #             :postal_code,
    #             :building_number,
    #             :unit_number,
    #             :name
    #         ] } ]
    #     else
    #         render json: { status: "error", message: "Merchant not found" }, status: 400 
    #     end
    # end

    # def createCustomer
    #     @user = User.new(user_params)
    #     @user.role = "customer"
    #     @user.identifiable = Customer.create!()
    #     # puts @user.errors.full_messages
    #     # puts 'test'
    #     if @user.save
    #         @user.send_activation_email
    #         token = encode_token({user_id: @user.id})
    #         render json: { status: "saved", user: @user, token: token }
    #         # render json: @user, only: [:id, :name, :email, :contact_number], status: 201
    #     else
    #         render json: { status: "error", message: @user.errors.full_messages.join("/n")}, status: 400 
    #     end
    # end

    # def createMerchant
    #     @user = User.new(user_params)
    #     @user.role = "merchant"
    #     @user.identifiable = Merchant.create!()
    #     # puts @user.errors.full_messages
    #     # puts 'test'
    #     if @user.save
    #         @user.send_activation_email
    #         token = encode_token({user_id: @user.id})
    #         render json: { status: "saved", user: @user, token: token }
    #         # render json: @user, only: [:id, :name, :email, :contact_number], status: 201
    #     else
    #         render json: { status: "error", message: @user.errors.full_messages.join("/n")}, status: 400 
    #     end
    # end

    

    # POST /api/v1/users
    def create
        # instance_variable = instance_variable_get("@#{controller_name.pluralize}")
        class_variable = controller_name.classify.constantize
        instance_variable = class_variable.new(user_params)

        if instance_variable.save
            instance_variable.send_activation_email
            token = encode_token({user_id: instance_variable.id})
            render json: { status: "saved", user: instance_variable, token: token }, status: 201
        else
            render json: { status: "error", message: instance_variable.errors.full_messages}, status: 400 
        end

    end

    # user = User.find_by(email: params[:session][:email].downcase)
    # if user && user.authenticate(params[:session][:password])

    # PUT /api/v1/users/:id
    def update
        instance_variable = instance_variable_get("@#{controller_name.pluralize}")
        class_variable = controller_name.classify.constantize
        instance_variable = class_variable.find_by(id: params[:id])

        if instance_variable
            if instance_variable.update(user_params)
                render json: { message: "User successfully updated" }, status: 200
            else
                render json: { status: "error", message: instance_variable.errors.full_messages}, status: 400 
            end
        else
            render json: { error: "User not found" }, status: 400
        end
    end

    # DELETE /api/v1/users/:id
    def destroy
        class_variable = controller_name.classify.constantize
        instance_variable = class_variable.find_by(id: params[:id])
        # byebug
        if instance_variable
            instance_variable.destroy
            render json: { message: "User successfully deleted." }, status: 204
        else
            render json: { error: "User does not exist." }, status: 400
        end
    end

    private
        def user_params
            params.permit(
                :name, 
                :email, 
                :contact_number, 
                :password, 
                :password_confirmation)
        end

        # Before filters
        def correct_user_filter
            # byebug
            @user = User.find(params[:id])
            
            render json: { message: 'Unauthorised user' },
                status: :unauthorized unless current_user?(@user) || current_user.admin?
        end

        def admin_user
            render json: { message: 'Unauthorised user' }, 
                status: :unauthorized unless current_user && current_user.admin?
        end

        def identify_user_in_params
            User.find(params[:id])
        end

        # def logged_in_user
        #     render json: { message: 'Please log in' }, status: :unauthorized unless logged_in?
        # end
        # end
    # end
end
