class Address < ApplicationRecord
    belongs_to :addressable, polymorphic: true
    validates :addressable_id, presence: true
    validates :addressable_type, presence: true
    with_options if: :not_drone do |not_drone|
        not_drone.validates :street_address, presence: true
        not_drone.validates :city, presence: true
        not_drone.validates :building_no, presence: true
        not_drone.validates :unit_number, presence: true
        not_drone.validates :name, presence: true
        not_drone.validates :country, presence: true
        not_drone.validates :postcode, presence: true
    end
    
    validates :latitude, presence: true
    validates :longitude, presence: true

    after_validation :geocode, if: :present_and_changed_or_missing_coords
    before_save :latlng_exist

    def present_and_changed_or_missing_coords
        (!country.nil? && !postcode.nil? && (self.postcode_changed? || country_changed?)) or (latitude.nil? || longitude.nil?)
    end

    reverse_geocoded_by :latitude, :longitude do |obj, results|
        # byebug
        if geo = results.first
            obj.city = geo.city
            obj.postcode = geo.postal_code
            obj.country = geo.country
            obj.city = geo.city
        end
    end

    before_validation :reverse_geocode, if: :drone
    
    def latlng_exist
        
    end

    def not_drone
        !(addressable_type == "Drone")
    end

    def drone
        (addressable_type == "Drone")
    end

    def deep_copy 
        new_add = Address.new(
            street_address: self.street_address,
            city: self.city,
            building_no: self.building_no,
            unit_number: self.unit_number,
            name: self.name,
            country: self.country,
            postcode: self.postcode,
            latitude: self.latitude,
            longitude: self.longitude
        )
        return new_add

        
    end



    def present_and_changed
        (postcode.present? and country.present?) and (postcode_changed? || country_changed?) 
    end
        
        
    
    def geocode_info
        [country, postcode].compact.join(', ')
    end

    geocoded_by :geocode_info
end
