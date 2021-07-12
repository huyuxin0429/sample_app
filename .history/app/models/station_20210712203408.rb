class Station < ApplicationRecord
    has_one :address, as: :addressable, dependent: :destroy
    has_many :edges, dependent: :destroy

end
