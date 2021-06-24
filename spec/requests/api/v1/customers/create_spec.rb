require 'rails_helper'

describe "POST api/v1/customers", type: :request do
    scenario 'valid customer attributes' do
        post '/api/v1/customers', params: {
            name: "didymus",
            contact_no: "12341234",
            email: "didy@test.com",
            password: "12341234",
            password_confirmation: "12341234"
        }

        expect(response.status).to eq(201)

        json = JSON.parse(response.body).deep_symbolize_keys
        user = json[:user]
        # check the value of the returned response hash
        expect(user[:name]).to eq('didymus')
        expect(user[:contact_no]).to eq(12341234)
        expect(user[:email]).to eq('didy@test.com')
    
        # 1 new bookmark record is created
        expect(Customer.count).to eq(1)
    end

    scenario 'invalid customer attributes' do
        post '/api/v1/customers', params: {
            name: "",
            contact_no: "",
            email: "",
            password: "12341234",
            password_confirmation: "123htj41234"
        }

        expect(response.status).to eq(400)

        json = JSON.parse(response.body).deep_symbolize_keys
        # check the value of the returned response hash
        expect(json[:status]).to eq('error')

        # 1 new bookmark record is created
        expect(Customer.count).to eq(0)
    end
    
end
