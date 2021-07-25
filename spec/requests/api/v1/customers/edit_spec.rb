require 'rails_helper'

describe "PATCH api/v1/customers", type: :request do
    let!(:customer) { Customer.create(
        id: 99999,
        name: "didy", 
        email: "didy@test.com", 
        contact_number: "12341234", 
        password: "12341234", 
        password_confirmation: "12341234",
        activated: true)
        }

    describe 'valid customer attributes' do
        it 'updates customer' do
            post '/api/v1/login', params: {
                email: "didy@test.com", 
                password: "12341234"
            }
            json = JSON.parse(response.body).deep_symbolize_keys
            # byebug
            id = json[:user_id]
            token = json[:token]

            patch '/api/v1/customers/99999', params: {
                name: "didymus",
                contact_number: "12341234",
                email: "didy@test.com",
                password: "12341234",
                password_confirmation: "12341234"
            }, headers: { "Authorization": "Bearer #{token}" }
    
            # byebug
            expect(response.status).to eq(200)
    
            json = JSON.parse(response.body).deep_symbolize_keys            # check the value of the returned response hash
            expect(json[:message]).to eq('User successfully updated')

        end
        
    end

    describe 'invalid customer attributes' do
        it 'does not update customer' do
            post '/api/v1/login', params: {
                email: "didy@test.com", 
                password: "12341234"
            }
            json = JSON.parse(response.body).deep_symbolize_keys
            # byebug
            id = json[:user_id]
            token = json[:token]

            patch '/api/v1/customers/99999', params: {
                name: "",
                contact_number: "",
                email: "",
                password: "12341234",
                password_confirmation: "123htj41234"
            }, headers: { "Authorization": "Bearer #{token}" }
    
            expect(response.status).to eq(400)
    
            json = JSON.parse(response.body).deep_symbolize_keys
            # check the value of the returned response hash
            expect(json[:status]).to eq('error')

        end
      
    end

    describe 'invalid customer' do
        
        it 'is not authorised' do
            post '/api/v1/login', params: {
                email: "didy@test.com", 
                password: "12341234"
            }
            json = JSON.parse(response.body).deep_symbolize_keys
            # byebug
            id = json[:user_id]
            token = json[:token]

            patch '/api/v1/customers/12341234', params: {
                name: "didymus",
                contact_number: "12341234",
                email: "didy@test.com",
                password: "12341234",
                password_confirmation: "12341234"
            }, headers: { "Authorization": "Bearer #{token}" }
            # byebug
            expect(response.status).to eq(401)
    
            json = JSON.parse(response.body).deep_symbolize_keys
            # check the value of the returned response hash
            expect(json[:message]).to eq('Unauthorised user')
            
        end
      
    end
    
end
