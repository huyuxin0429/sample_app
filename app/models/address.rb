class Address < ApplicationRecord
    belongs_to :addressable, polymorphic: true
    validates :addressable_id, presence: true
    validates :addressable_type, presence: true
    with_options if: :need_be_specific do |specific|
        specific.validates :street_address, presence: true
        specific.validates :city, presence: true
        specific.validates :building_number, presence: true, numericality: { only_integer: true }
        specific.validates :unit_number, presence: true
        specific.validates :name, presence: true
        specific.validates :country, presence: true
        specific.validates :postal_code, presence: true, numericality: { only_integer: true }
    end
    before_destroy :deleteOrder

    def deleteOrder
        orders = Order.where(pick_up_address_id: self.id).or(Order.where(drop_off_address_id: self.id))
        orders.each { |order|
            order.destroy
        
        }
    end
    
    validates :latitude, presence: true
    validates :longitude, presence: true

    after_validation :geocode, if: :present_and_changed_or_missing_coords
    before_save :latlng_exist

    def present_and_changed_or_missing_coords
        (!country.nil? && !postal_code.nil? && (self.postal_code_changed? || country_changed?)) or (latitude.nil? || longitude.nil?)
    end

    reverse_geocoded_by :latitude, :longitude do |obj, results|
        # byebug
        if geo = results.first
            obj.city = geo.city
            obj.postal_code = geo.postal_code
            obj.country = geo.country
            obj.city = geo.city
        end
    end

    before_validation :reverse_geocode, if: :no_need_be_specific
    
    def latlng_exist
        
    end

    def need_be_specific
        !no_need_be_specific
    end

    def no_need_be_specific
        (addressable_type == "Drone" || 
            addressable_type == "Station" )
    end

    def deep_copy 
        new_add = Address.new(
            street_address: self.street_address,
            city: self.city,
            building_number: self.building_number,
            unit_number: self.unit_number,
            name: self.name,
            country: self.country,
            postal_code: self.postal_code,
            latitude: self.latitude,
            longitude: self.longitude
        )
        return new_add

        
    end



    def present_and_changed
        (postal_code.present? and country.present?) and (postal_code_changed? || country_changed?) 
    end
        
        
    
    def geocode_info
        [country, postal_code].compact.join(', ')
    end

    geocoded_by :geocode_info
end
