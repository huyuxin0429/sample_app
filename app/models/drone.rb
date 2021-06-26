class Drone < ApplicationRecord
  has_one :order
  has_one :current_address, class_name: "Address", as: :addressable, dependent: :destroy # Cant use any other word other than address/addressable, no idea why
  has_one :target_address, class_name: "Address", as: :addressable, dependent: :destroy

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

  def is_free?
   free_stationary? || free_moving?
  end

  def is_moving?
    free_moving? || heading_to_pickup? || heading_to_drop_off?
  end


  def simulate(time_delta)
    if is_moving?
      approach(target_address, time_delta)
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

  def deliver(order)
    self.order = order
    self.target_address = Address.find(id: order.pick_up_address_id)
    heading_to_pickup!
  end

  private

    def approach(address, time_delta)

      curr_distance = Geocoder::Calculations.distance_between(current_address, target_address)
      new_distance = speed * time_delta

      

      if (curr_distance < new_distance)
        current_address = target_address
        next_status
      else
        bearing = Geocoder::Calculations.bearing_between(current_address, target_address)
        current_address = Geocoder::Calculations.endpoint(current_address, bearing, new_distance)
      end
    end

    def next_status
      if free_moving?
        free_stationary!
      elsif heading_to_pickup?
        wating_for_pickup!
      elsif heading_to_drop_off?
        order.awaiting_customer_pickup!
        wating_for_drop_off!
      end
    end

end
