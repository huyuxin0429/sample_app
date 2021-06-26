class Address < ApplicationRecord
    belongs_to :addressable, polymorphic: true
    with_options if: :not_drone do |not_drone|
        not_drone.validates :street_address, presence: true
        not_drone.validates :city, presence: true
        not_drone.validates :building_no, presence: true
        not_drone.validates :unit_number, presence: true
        not_drone.validates :name, presence: true
    end
    validates :country, presence: true
    validates :postcode, presence: true
    before_save :geocode, if: :present_and_changed
    

    def not_drone
        !(addressable_type == "Drone")
    end



    def present_and_changed
        (postcode.present? and country.present?) and (postcode_changed? || country_changed?) 
    end
        
        
    
    def geocode_info
        [country, postcode].compact.join(', ')
    end

    geocoded_by :geocode_info
end
