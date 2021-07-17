class Api::V1::OrdersController < Api::V1::BaseController
     # skip_before_action :verify_authenticity_token
     before_action :logged_in_user_filter, only: [:create, :destroy, :index, :show]
     before_action :correct_user_filter, only: [:destroy, :index, :show]
     # before_action :admin_user_filter, only: [:destroy, :index, :create, :show]
     before_action :ensure_valid_merchant_product_params, only: [:destroy, :index, :show]
     def new
         
     end


     def custUpdateOrder
        # byebug
        order = stated_user.orders.find_by(id: params[:order_id])


        if order and order.status == "awaiting_customer_pickup"
            order.progress
            render json: { message: "Order delivered"}, status: 200
        else
            render json: { message: "Invalid status or order does not exist"}, status: 400

        end
     end

     def merchantUpdateOrder
        order = stated_user.orders.find(params[:order_id])
        if order.status == "merchant_preparing"
            order.progress
            render json: { message: "Order picked up"}, status: 200
        else
            render json: { message: "Invalid status or order does not exist"}, status: 400
        end
     end
 
     def stated_user
        if params.key?(:customer_id)
         user_id_name = :customer_id
        elsif params.key?(:merchant_id)
            user_id_name = :merchant_id
        end

         User.find(params[user_id_name])
     end
 
     # Custom errors for create action
     class OrderingErrors < StandardError
        attr_reader :detailed_message
        
        def initialize(detailed_message='')
            super
            @detailed_message = detailed_message
        end

        def message
            "Error while ordering"
        end
     end

     # POST /api/v1/users/:id/orders
     def create
        


        begin
            @customer = Customer.find_by(id: params[:customer_id])
            if @customer.nil?
                raise OrderingErrors.new("Invalid customer")
            end
            @merchant = Merchant.find_by(id: params[:merchant_id])
            if @merchant.nil?
                raise OrderingErrors.new("Invalid merchant")
            end
            #  byebug
            @order = Order.new
            @order.customer = @customer
            @order.merchant = @merchant
            @order.pick_up_address_id = params[:pick_up_address_id]
            @order.drop_off_address_id = params[:drop_off_address_id]
            @order.total_price = params[:total_price]
            order_entries_raw = params[:order_entries]
            order_entries_raw.each{|raw_entry|
                
                filtered_params = raw_entry.permit(
                    :product_id,
                    :units_bought
                    )
                @order_entry = OrderEntry.new(filtered_params)
                @order_entry.order = @order
                if !@order_entry.save
                    # byebug
                    raise OrderingErrors.new(@order_entry.errors.full_messages) #message: @order_entry.errors.full_messages.join("/n") 
                end
                @order.order_entries << @order_entry
            }
            # byebug
            if !@order.save
                raise OrderingErrors.new(@order.errors.full_messages) #message: @order.errors.full_messages.join("/n") }
            end
        rescue OrderingErrors => error
            render json: { message: error.message, details: error.detailed_message  }, status: 400

        else
            render json: { message: "Order created"}, status: 201
        end
     end
 
     # GET /api/v1/users/:id/orders
     def index
         # @user = User.find(params[:user_id])
        #  byebug
         @orders = stated_user.orders.all;
         
         render json: @orders, include:
            [:order_entries]
     end

     def outstandingOrders
        @orders = stated_user.orders.outstandingOrders
         
        render json: @orders
     end
 
 
     # PUT api/v1/users/:user_id/orders/:id
     def update
        # begin
        #     @customer = Customer.find_by(id: params[:customer_id])
        #     if @customer.nil? || @customer != stated_user
        #         raise InvalidCustomerError
        #     end
        #     @merchant = Merchant.find_by(id: params[:merchant_id])
        #     if @merchant.nil?
        #         raise InvalidMerchantError
        #     end
        #     # @user = User.find(params[:user_id])
        #     if !@customer.orders || !@order = @customer.orders.find_by(id: params[:id])
        #         raise OrderError("Order does not exist")
        #     end

        #     if !@order.update(update_params)
        #         raise OrderError.new(@order.errors.full_messages)
        #     end
        # rescue OrderingErrors => error
        #     render json: { message: error.message, detailed_message: error.detailed_message }, status: 400
        # else
        #     render json: { message: "Order successfully updated" }, status: 200
        # end
     end
 
     # GET /api/v1/users/:id/orders/:address_id
     def show
         # @user = User.find(params[:user_id])
         @order = stated_user.orders.find_by(id: params[:id])
        #  byebug
         if @order
             render json: @order, include:
             [:order_entries]
         else
             render json: { error: "Order does not exist." }, status: 400
         end
         
     end
 
     # DELETE /api/v1/users/:id/orders/:address_id
     def destroy
         # @user = User.find(params[:user_id])
         if stated_user.orders && 
             @order = stated_user.orders.find_by(id: params[:id])
             @order.destroy
             render json: { message: "Order destroyed"}, status: 204
         else
             render json: { error: "Order does not exist." }, status: 400
         end
  
       
     end
 
     private
         def order_params
             params.permit(
                :customer_id,
                :pick_up_address_id,
                :drop_off_address_id,
                :merchant_id,
                :order_entries
             )
         end

        #  def update_params
        #     params.permit(
        #        :customer_id,
        #        :merchant_id
        #     )
        # end
 
         def correct_user_filter
             # byebug
             
             if params.has_key?(:customer_id)
                 @user = Customer.find_by(id: params[:customer_id])
             elsif params.has_key?(:merchant_id)
                 @user = Merchant.find_by(id: params[:merchant_id])
             end
             
             render json: { message: 'Unauthorised user' },
                 status: :unauthorized unless current_user?(stated_user) || current_user.admin?
         end

         def ensure_valid_merchant_product_params
            merchant_pass = true
            product_pass = true
            if params.has_key?(:merchant_id)
                 @merchant = Merchant.find_by(id: params[:merchant_id])
                 merchant_pass = !@merchant.nil?
                if merchant_pass
                    if params.has_key?(:product_id)
                        @product = Product.find_by(id: params[:product_id])
                        product_pass = @merchant.products.include?(@product)
                    end
                end
            end
            
            render json: { message: 'Invalid product/merchant' },
                 status: :unauthorized unless product_pass && merchant_pass
            
         end
 
end
