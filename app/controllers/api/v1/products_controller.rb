class Api::V1::ProductsController < Api::V1::BaseController
    before_action :logged_in_user_filter, only: [:create, :destroy, :index, :show]
    before_action :correct_user_filter, only: [:destroy, :index, :create, :show]

    def new
        
    end

    

    # POST /api/v1/users/:id/products
    def create
        @merchant = Merchant.find(params[:merchant_id])
        @product = @merchant.products.build(product_params)
        if @product.save
            render json: { message: "Product created"}, status: 201
        else
            render json: { status: "error", 
                message: @product.errors.full_messages.join("/n") }, 
                status: 401
        end
    end

    # GET /api/v1/users/:id/products
    def index
        @merchant = Merchant.find(params[:merchant_id])
        # byebug
        @products = @merchant.products.all;
        render json: @products
        # , only: [
            
        #     :name,
        #     :price,
        #     :quantity,
        #     :description,
        #     :image
        # ]
    end


    # PUT api/v1/users/:user_id/products/:id
    def update
        @merchant = Merchant.find(params[:merchant_id])
        # @user = User.find(params[:user_id])
        if @merchant.products && 
            @product = @merchant.products.find_by(id: params[:id])
            if @product.update(product_params)
                render json: { message: "Product successfully updated" }, status: 200
            else
                render json: { status: "error", message: @product.errors.full_messages.join("/n")}, status: 400 
            end
        else
            render json: { error: "Product not found" }, status: 400
        end
    end

    # GET /api/v1/users/:id/products/:product_id
    def show
        @merchant = Merchant.find(params[:merchant_id])
        @product = @merchant.products.find_by(id: params[:id])
        if @product
            render json: @product
            # , only: [
            #     :name,
            #     :price,
            #     :description,
            #     :image
            # ]
        else
            render json: { error: "Product does not exist." }, status: 400
        end
        
    end

    # DELETE /api/v1/users/:id/products/:product_id
    def destroy
        @merchant = Merchant.find(params[:merchant_id])
        if @merchant.products && 
            @product = @merchant.products.find_by(id: params[:id])
            @product.destroy
            render json: { message: "Product destroyed"}, status: 204
        else
            render json: { error: "Product does not exist." }, status: 400
        end
 
      
    end

    private
        def product_params
            params.permit(
                :name,
                :price,
                :quantity,
                :merchant_id,
                :description,
                :image
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
                status: :unauthorized unless current_user?(@user) || current_user.admin?
        end
end
