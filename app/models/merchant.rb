class Merchant < ApplicationRecord
    before_save { email.downcase! }
    validates :company_name, presence: true, length: { maximum: 50 }
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, length: { maximum: 255 }, 
        format: { with: VALID_EMAIL_REGEX }, 
        uniqueness: true
    validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
    validates :address, presence: true
    ALL_NUMBER_REGEX =  /\A[0-9]*$\z/
    validates :contact_no, presence: true, 
        format: { with: ALL_NUMBER_REGEX }, length: { is: 8}
    has_secure_password

    def Merchant.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ?
        BCrypt::Engine::MIN_COST :
        BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end
end
