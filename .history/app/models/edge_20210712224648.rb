class Edge < ApplicationRecord
    validates :src_id, presence: true
    validates :dest_id, presence: true
    validates :cost, presence: true



end
