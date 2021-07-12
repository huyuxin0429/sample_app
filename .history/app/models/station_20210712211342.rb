class Station < ApplicationRecord
    has_one :address, as: :addressable, dependent: :destroy
    has_many :edges, dependent: :destroy

    validates :provided_id, presence: true

end
