describe "POST api/v1/login", type: :request do
    let!(:customer) { Customer.create(
        id: 9999999,
        name: "didy", 
        email: "didy@test.com", 
        contact_number: "12341234", 
        password: "12341234", 
        password_confirmation: "12341234",
    activated: true)
        }

    describe 'valid logging in' do
        it 'logs user in' do
            post '/api/v1/login', params: {
                email: "didy@test.com", 
                password: "12341234"
            }
            json = JSON.parse(response.body).deep_symbolize_keys
            # byebug
            # id = json[:user_id]
            # token = json[:token]
            expect(json[:message]).to eq("Login successful")
        end
        
       
        # byebug
        # token = "Bearer " + token
        # request.headers["Authorization"] = token
        # request.headers.merge!(authenticated_header("admin", "123"))
        # get "/api/v1/customers/#{id}", headers: { "Authorization": "Bearer #{token}" }
        # # process :get, "/api/v1/customers/#{id}", headers: { "Authorization" => token }
        # # byebug
        # expect(response.status).to eq(200)

        # json = JSON.parse(response.body).deep_symbolize_keys
        # # user = json[:user]
        # # # check the value of the returned response hash
        # # expect(json[:message]).to eq('Login successful')
        # expect(json[:name]).to eq('didy')
        # expect(json[:contact_number]).to eq(12341234)
        # expect(json[:email]).to eq('didy@test.com')

    end

    describe 'invalid logging in' do
        it 'does not log user in' do
            post '/api/v1/login', params: {
                email: "didsdsddy@test.com", 
                password: "12341234"
            }
            json = JSON.parse(response.body).deep_symbolize_keys
            # byebug
            # id = json[:user_id]
            # token = json[:token]
            expect(json[:message]).to eq("User not found")
            expect(response.status).to eq(401)
        end
        
      
        # byebug
        # token = "Bearer " + token
        # request.headers["Authorization"] = token
        # request.headers.merge!(authenticated_header("admin", "123"))
        # get "/api/v1/customers/#{id}", headers: { "Authorization": "Bearer #{token}" }
        # # process :get, "/api/v1/customers/#{id}", headers: { "Authorization" => token }
        # # byebug
        # expect(response.status).to eq(200)

        # json = JSON.parse(response.body).deep_symbolize_keys
        # # user = json[:user]
        # # # check the value of the returned response hash
        # # expect(json[:message]).to eq('Login successful')
        # expect(json[:name]).to eq('didy')
        # expect(json[:contact_number]).to eq(12341234)
        # expect(json[:email]).to eq('didy@test.com')

    end


    
end