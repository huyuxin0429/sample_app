def login_and_get_token(:user)
    post '/api/v1/login', params: {
        email: "didy@test.com", 
        password: "12341234"
    }
    json = JSON.parse(response.body).deep_symbolize_keys
    # byebug
    id = json[:user_id]
    token = json[:token]
end