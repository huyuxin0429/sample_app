module ApplicationCable
    class Connection < ActionCable::Connection::Base
        identified_by :current_user


        def connect
            self.current_user = find_verified_user
        end

#     def auth_header
#       # { Authorization: 'Bearer <token>' }
#           request.headers[:HTTP_SEC_WEBSOCKET_PROTOCOL]
#     end

    def decode_token(token)

      # byebug
          begin
              return JWT.decode(token, 'yourSecret', true, algorithm: 'HS256')
              
          # rescue JWT::ExpiredSignature
          #     render json: { status: "error", 
          #         message: "login token expired" }, 
          #         status: 403
          rescue JWT::DecodeError  
            reject_unauthorized_connection
              # render json: { status: "error", 
              #     message: "invalid token" }, 
              #     status: 401

          end
      
     end

        def find_verified_user
            token = request.params[:token]
            if token && decode_token(token)
                id = decode_token(token)[0]["data"]["user_id"]
                # byebug
                if current_user = User.find_by(id: id)
                    current_user
                else
                    reject_unauthorized_connection
                end
            end

        end

    end

end
