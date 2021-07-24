class Api::V1::OrderEntriesController < Api::V1::BaseController
    
     # skip_before_action :verify_authenticity_token
     before_action :logged_in_user_filter, only: [:create, :destroy, :index, :show]
     before_action :correct_user_filter, only: [:destroy, :index, :create, :show]
     # before_action :admin_user_filter, only: [:destroy, :index, :create, :show]
     before_action :ensure_valid_merchant_product_params, only: [:destroy, :index, :create, :show]
     def new
         
     end
 
     def stated_user
         user_id_name = params.keys.fourth.to_sym
         User.find(params[user_id_name])
     end

     def stated_order
        Order.find(params[:order_id])
     end
 
     
 
     # POST /api/v1/users/:id/order_entries
     def create
         # @user = Users.find(params[:user_id])
         @order_entry = stated_order.order_entries.build(product_entries_params)
         if @order_entry.save
             render json: { message: "Order entry created"}, status: 201
         else
             render json: { status: "error", 
                 message: @order_entry.errors.full_messages.join("/n") }, 
                 status: 401
         end
     end
 
     # GET /api/v1/users/:id/order_entries
     def index
         # @user = User.find(params[:user_id])
        #  byebug
         @order_entries = stated_order.order_entries.all;
         
         render json: @order_entries, include:
            [:product]
     end
 
 
     # PUT api/v1/users/:user_id/order_entries/:id
     def update
         # @user = User.find(params[:user_id])
         if stated_user.order_entries && 
             @order_entry = stated_user.order_entries.find_by(id: params[:id])
             if @order_entry.update(product_entries_params)
                 render json: { message: "Order entry successfully updated" }, status: 200
             else
                 render json: { status: "error", message: @order_entry.errors.full_messages.join("/n")}, status: 400 
             end
         else
             render json: { error: "Order entry not found" }, status: 400
         end
     end
 
     # GET /api/v1/users/:id/order_entries/:address_id
     def show
         # @user = User.find(params[:user_id])
         @order_entry = stated_order.order_entries.find_by(id: params[:id])
         if @order_entry
             render json: @order_entry, include:
             [:product]
         else
             render json: { error: "Order entry does not exist." }, status: 400
         end
         
     end
 
     # DELETE /api/v1/users/:id/order_entries/:address_id
     def destroy
         # @user = User.find(params[:user_id])
         if stated_order.order_entries && 
             @order_entry = stated_order.order_entries.find_by(id: params[:id])
             @order_entry.destroy
             render json: { message: "Order entry destroyed"}, status: 204
         else
             render json: { error: "Order entry does not exist." }, status: 400
         end
  
       
     end
 
     private
         def product_entries_params
             params.permit(
                 :street_address,
                 :city,
                 :country,
                 :postal_code,
                 :building_no,
                 :unit_number,
                 :name)
         end
 
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
            order_pass = true
            if params.has_key?(:merchant_id)
                 @merchant = Merchant.find_by(id: params[:merchant_id])
                 merchant_pass = !@merchant.nil?
                if merchant_pass
                    if params.has_key?(:product_id)
                        @product = Product.find_by(id: params[:product_id])
                        product_pass = @merchant.products.include?(@product)
                        if product_pass
                            @order = Order.find_by(id: params[:order_id])
                            order_pass = @product.orders.include?(@order)
                        end
                    end
                end
            end
            
            render json: { message: 'Invalid product/merchant/order' },
                 status: :unauthorized unless product_pass && merchant_pass && order_pass
            
         end
end
