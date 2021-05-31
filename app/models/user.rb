class User < ApplicationRecord

    attr_accessor :remember_token

    before_save { email.downcase! }
    validates :name, presence: true, length: { maximum: 50 }
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

    enum role: [:user, :merchant, :logistics, :admin]
    after_initialize :set_default_role, :if => :new_record?

    def User.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ?
        BCrypt::Engine::MIN_COST :
        BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end

    # Returns a new random token
    def User.new_token
        SecureRandom.urlsafe_base64
    end

    # Remember as user in the database for use in persistent sessions.
    def remember
        self.remember_token = User.new_token
        update_attribute(:remember_digest, User.digest(remember_token))
    end

    # Returns true if the given token matches the digest.
    def authenticated?(remember_token)
        return false if remember_digest.nil?
        BCrypt::Password.new(remember_digest) == remember_token
        #BCrypt::Password.new(remember_digest).is_password?(remember_token)
    end

    # Forgets a user
    def forget
        update_attribute(:remember_digest, nil)
    end

    def set_default_role
        self.role ||= :user
      end
end
