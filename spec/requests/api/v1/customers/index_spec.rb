require 'rails_helper'
require 'net/http'  
require 'customer_helper'

describe "GET api/v1/customers/", type: :request do
   

    let!(:customer) { Customer.create(
        name: "didy", 
        email: "didy@test.com", 
        contact_number: "12341234", 
        password: "12341234", 
        password_confirmation: "12341234",
        activated: true)
    }


    let!(:admin) { User.create(
        name: "admin", 
        email: "admin@test.com", 
        contact_number: "12341234", 
        password: "12341234", 
        password_confirmation: "12341234",
        activated: true,
        admin:true)
    }

    scenario 'view index without logging in' do
        get '/api/v1/customers'
        # byebug
        expect(response.status).to eq(401)

        json = JSON.parse(response.body).deep_symbolize_keys
        # check the value of the returned response hash
        expect(json[:message]).to eq('Unauthorised user')

    end

    scenario 'view index after logging in as customer' do

        token2 = encode_token( {"user_id" => customer.id} )
        get "/api/v1/customers/", headers: { "Authorization": "Bearer #{token2}" }
        expect(response.status).to eq(401)


    end

    scenario 'view index after logging in as admin' do


        token2 = encode_token( {"user_id" => admin.id} )
        get "/api/v1/customers/", headers: { "Authorization": "Bearer #{token2}" }
        expect(response.status).to eq(200)
        
        
        json_array = JSON.parse(response.body)
        json_didy = json_array[0].deep_symbolize_keys
        # byebug
        expect(json_didy[:name]).to eq('didy')
        expect(json_didy[:contact_number]).to eq(12341234)
        expect(json_didy[:email]).to eq('didy@test.com')
        

    end


    
end