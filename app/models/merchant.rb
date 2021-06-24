class Merchant < User
    # has_one :identity, :class_name => "User", :foreign_key => "identifiable_id", dependent: :destroy
    has_many :products, dependent: :destroy
    has_many :orders, through: :products, dependent: :destroy

end
