class Merchant < ApplicationRecord
    has_one :identity, as: :identifiable
    has_many :products, dependent: :destroy

end
