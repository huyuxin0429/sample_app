class Drone < ApplicationRecord
  has_one :order
  has_one :address, as: :addressable, dependent: :destroy
  # has_one :current_address, as: :addressable, dependent: :destroy

  # reverse_geocoded_by :latitude, :longitude, address: :full_address
  # after_validation :reverse_geocode, if: :present_and_changed

  # def present_and_changed
  #   (latitude.present? and longitude.present?) and (latitude_changed? || longitude_changed?)
  # end

  enum status: { 
    free_stationary: "free_stationary", 
    free_moving: "free_moving", 
    heading_to_pickup: "heading_to_pickup",
    waiting_for_pickup: "waiting_for_pickup", 
    heading_to_drop_off: "heading_to_drop_off", 
    waiting_for_drop_off: "waiting_for_drop_off"
  }

  


  def simulate(time_delta)
    if free_moving?
      approach(free_address, time_delta)
    elsif heading_to_pickup?
      address = Address.find(id: order.pick_up_address_id)
      approach(address, time_delta)
    elsif heading_to_drop_off?
      address = Address.find(id: order.drop_off_address_id)
      approach(address, time_delta)
    elsif wating_for_pickup?
      if order.awaiting_drone_pickup?
        order.enroute_to_customer!
        heading_to_drop_off!
      end
    elsif wating_for_drop_off?
      if order.completed?
        free_stationary!
      end
    end
  end

  private

    def approach(address, time_delta)

      curr_distance = Geocoder::Calculations.distance_between(address, current_address)
      new_distance = speed * time_delta

      # if (curr_distance < new_distance)
      #   latitude = address.latitude
      #   longitude = address.longitude
      # else
      #   direction_vector /= direction_vector.magnitude
      #   new_location_vector = curr_location_vector + speed * time_delta * direction_vector
      #   latitude = new_location_vector[0]
      #   longitude = new_location_vector[1]

      #   next_status
      # end
    end

    def next_status
      if free_moving?
        status.free_stationary!
      elsif heading_to_pickup?
        status.wating_for_pickup!
      elsif heading_to_drop_off?
        order.awaiting_customer_pickup!
        status.wating_for_drop_off!
      end
    end

end
