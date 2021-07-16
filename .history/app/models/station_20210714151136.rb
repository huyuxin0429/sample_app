class Station < ApplicationRecord
    has_one :address, as: :addressable, dependent: :destroy

    validates :provided_id, presence: true

    serialize :edges

end
