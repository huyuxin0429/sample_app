
def encode_token(data)
    expiry = Time.now.to_i + 4 * 3600 # 4 Hour usage time per token
    # puts expiry
    payload = { data: data, exp: expiry }
    # puts JWT.encode(payload, 'yourSecret')
    JWT.encode(payload, 'yourSecret')
end


def login_and_get_token(user)
    post '/api/v1/login', params: {
        email: "didy@test.com", 
        password: "12341234"
    }
    json = JSON.parse(response.body).deep_symbolize_keys
    # byebug
    id = json[:user_id]
    token = json[:token]
end