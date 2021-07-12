class Edge < ApplicationRecord
    validates :src, presence: true
    validates :dest, presence: true
    validates :cost, presence: true



end
