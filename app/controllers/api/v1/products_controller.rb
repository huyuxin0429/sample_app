class Api::V1::ProductsController < Api::V1::BaseController
    before_action :logged_in_user_filter, only: [:create, :destroy, :index, :show]
    before_action :correct_user_filter, only: [:destroy, :index, :create, :show]

    def new
        
    end

    

    # POST /api/v1/users/:id/products
    def create
        # @user = Users.find(params[:user_id])
        current_user
        @product = current_user.products.build(product_params)
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
        # byebug
        # @user = User.find(params[:user_id])
        @products = current_user.products.all;
        render json: @products, only: [
            :name,
            :price,
            :description,
            :image
        ]
    end


    # PUT api/v1/users/:user_id/products/:id
    def update
        # @user = User.find(params[:user_id])
        if current_user.products && 
            @product = current_user.products.find_by(id: params[:id])
            if @product.update(product_params)
                render json: { message: "Address successfully updated" }, status: 200
            else
                render json: { status: "error", message: @product.errors.full_messages.join("/n")}, status: 400 
            end
        else
            render json: { error: "Address not found" }, status: 400
        end
    end

    # GET /api/v1/users/:id/products/:product_id
    def show
        # @user = User.find(params[:user_id])
        @product = current_user.products.find_by(id: params[:id])
        if @product
            render json: @product, only: [
                :name,
                :price,
                :description,
                :image
            ]
        else
            render json: { error: "Address does not exist." }, status: 400
        end
        
    end

    # DELETE /api/v1/users/:id/products/:product_id
    def destroy
        # @user = User.find(params[:user_id])
        if current_user.products && 
            @product = current_user.products.find_by(id: params[:id])
            @product.destroy
            render json: { message: "Address destroyed"}, status: 204
        else
            render json: { error: "Address does not exist." }, status: 400
        end
 
      
    end

    private
        def product_params
            params.permit(
                :name,
                :price,
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
