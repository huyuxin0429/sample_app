class Merchant < ApplicationRecord
    attr_accessor :merchant_remember_token
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

# Remembers a merchant in the database for use in persistent sessions.
    def remember
        self.merchant_remember_token = User.new_token
        update_attribute(:merchant_remember_digest, 
                        User.digest(merchant_remember_token))
    end

    # Forgets a merchant
    def forget
        update_attribute(:merchant_remember_digest, nil)
    end

    # Returns true if the given token matches the digest.
    def authenticated?(merchant_remember_token)
        return false if merchant_remember_digest.nil?
        BCrypt::Password.new(merchant_remember_digest) == merchant_remember_token
        
    end
end
