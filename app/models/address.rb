class Address < ApplicationRecord
    belongs_to :user
    validates :street_address, presence: true
    validates :city, presence: true
    validates :country, presence: true
    validates :postcode, presence: true
    validates :building_no, presence: true
    validates :unit_number, presence: true
    validates :name, presence: true
    before_save :geocode
    
    def geocode_info
        [country, postcode].compact.join(', ')
    end

    geocoded_by :geocode_info
end
