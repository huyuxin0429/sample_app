class Customer < User
    # has_one :identity, :class_name => "User", :foreign_key => "identifiable_id", dependent: :destroy
    has_many :orders, dependent: :destroy
end
