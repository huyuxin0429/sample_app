class Station < ApplicationRecord
    has_one :address, as: :addressable, dependent: :destroy

    validates :provided_id, presence: true

    has_and_belongs_to_many :edges

    before_destroy do
        edges.each { |edge| edge.destroy}
    end


end
