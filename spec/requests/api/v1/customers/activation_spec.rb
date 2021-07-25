require 'rails_helper'

describe "POST api/v1/account_activation", type: :request do
    let!(:customer) { Customer.create(
        name: "didy", 
        email: "didy@test.com", 
        contact_number: "12341234", 
        password: "12341234", 
        password_confirmation: "12341234")
        }


        scenario 'no account activation' do
        
            expect(customer.reload.activated?).to eq(false)
    
        end
        
        scenario 'valid account activation' do
            # byebug
            get edit_api_v1_account_activation_url(customer.activation_token, email: customer.email)
            # byebug
            expect(response.status).to eq(200)
            # byebug
            expect(customer.reload.activated?).to eq(true)

        end

        scenario 'invalid account activation' do
            # byebug
            get edit_api_v1_account_activation_url(customer.activation_token, email: "invalid email")
            expect(response.status).to eq(403)
            expect(customer.reload.activated?).to eq(false)

        end
        scenario 'invalid account activation' do
            # byebug
            get edit_api_v1_account_activation_url("invalid token", email: customer.email)
            expect(response.status).to eq(403)
            expect(customer.reload.activated?).to eq(false)

        end

    # expect(customer.activated).to eq(false)

    # get edit_account_activation_path("invalid token", email: user.email)
    # expect(customer.activated).to eq(false)

    # get edit_account_activation_path(customer.activation_token, email: "invalid email")
    # expect(customer.activated).to eq(false)
    



end




    