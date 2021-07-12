class Station < ApplicationRecord
    has_one :address, as: :addressable, dependent: :destroy
    
    attr_reader :value, :from_edges, :to_edges
    def initialize(value)
        @value = value
        @from_edges = []
        @to_edges = []
    end

    def inspect
        value
    end
end
