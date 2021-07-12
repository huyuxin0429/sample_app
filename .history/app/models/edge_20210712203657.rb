class Edge < ApplicationRecord
    validates :src, presence: true
    validates :dest, presence: true
    validates :cost, presence: true

    attr_reader :src, :dest, :cost
    attr_writer :cost


end
