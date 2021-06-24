class Api::V1::BaseController <  ActionController::API

    # include SessionsHelper

    # def logged_in_user
    #     unless logged_in?
    #         store_location
    #         flash[:danger] = "Please log in"
    #         redirect_to login_url
    #     end
    # end

    

    
    def encode_token(data)
        expiry = Time.now.to_i + 4 * 3600 # 4 Hour usage time per token
        # puts expiry
        payload = { data: data, exp: expiry }
        # puts JWT.encode(payload, 'yourSecret')
        JWT.encode(payload, 'yourSecret')
    end
    
    def auth_header
    # { Authorization: 'Bearer <token>' }
        request.headers['Authorization']
    end

    def decoded_token
        if auth_header
            token = auth_header.split(' ')[1]
            # header: { 'Authorization': 'Bearer <token>' }
            begin
                return JWT.decode(token, 'yourSecret', true, algorithm: 'HS256')
                
            # rescue JWT::ExpiredSignature
            #     render json: { status: "error", 
            #         message: "login token expired" }, 
            #         status: 403
            rescue JWT::DecodeError  
                
                # render json: { status: "error", 
                #     message: "invalid token" }, 
                #     status: 401
                nil
            end
        end
    end

    def current_user
        if decoded_token
            # step1 = decoded_token[0]
            # step2 = step1["data"]
            # step3 = step2["user_id"].to_i
            # byebug
            user_id = decoded_token[0]["data"]["user_id"]
            @user = User.find_by(id: user_id)
            # byebug

        end
                
    end

    def current_merchant
        if decoded_token
            merchant_id = decoded_token[0]['data']['user_id']
            # byebug
            @merchant = Merchant.find_by(id: merchant_id)
        end
    end

    def logged_in?
        !!current_user
        # byebug
    end

    def logged_in_user_filter
        render json: { message: 'Please log in' }, status: :unauthorized unless logged_in?
    end

    def current_user?(user)
        user && user == current_user
    end

    

    def admin_user_filter
        render json: { message: 'Unauthorised user' }, 
            status: :unauthorized unless current_user && current_user.admin?
    end
end