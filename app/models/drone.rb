class Drone < ApplicationRecord
  has_one :order
  has_one :current_address, class_name: "Address", as: :addressable, dependent: :destroy # Cant use any other word other than address/addressable, no idea why
  # has_one :target_address, class_name: "Address", as: :addressable, dependent: :destroy
  

  # reverse_geocoded_by :latitude, :longitude, address: :full_address
  # after_validation :reverse_geocode, if: :present_and_changed

  # def present_and_changed
  #   (latitude.present? and longitude.present?) and (latitude_changed? || longitude_changed?)
  # end
  validates :current_address, presence: true

  scope :free, ->() {
    where(status: "free_stationary").or(where(status: "free_moving"))
  }

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
    # byebug
    changed = false
    if is_moving?
      # byebug
      approach(destination_address_id, time_delta)
      changed = true
    elsif waiting_for_pickup?
      # byebug
      if order.awaiting_drone_pickup?
        # byebug
        self.destination_address_id = order.drop_off_address_id
        # byebug
        changed = true
        order.enroute_to_customer!
        # byebug
        heading_to_drop_off!
        # byebug
      end
    elsif waiting_for_drop_off?
      if order.completed?
        changed = true
        free_stationary!
        # self.destination_address_id = nil
        order.drone = nil
        self.order = nil
      end
    end
    save!
    if changed
      destination_address = Address.find(destination_address_id)
      # output_json = self.to_json + self.current_address.to_json + destination_address.to_json
      ActionCable.server.broadcast 'drone_channel', self.to_json
      ActionCable.server.broadcast 'drone_channel', self.current_address.to_json
      ActionCable.server.broadcast 'drone_channel', destination_address.to_json
      # ActionCable.server.broadcast "drone_channel_user#{order.customer_id}", self.to_json
      # ActionCable.server.broadcast "drone_channel_user#{order.merchant_id}", self.to_json
    end
    
  end

  def deliver(order)
    self.order = order
    self.destination_address_id = order.pick_up_address_id
    # byebug
    heading_to_pickup!
    self.save!
    # byebug
    
  end

  private

    def approach(target_id, time_delta)
      # byebug
      target_address = Address.find(target_id)


      curr_distance = Geocoder::Calculations.distance_between(self.current_address, target_address)
      new_distance = speed * time_delta

      
      # byebug
      if (curr_distance < new_distance)
        self.current_address = target_address.deep_copy
        self.current_address.save!
        next_status
      else
        bearing = Geocoder::Calculations.bearing_between(self.current_address, target_address)
        new_lat_lng = Geocoder::Calculations.endpoint(self.current_address, bearing, new_distance)
        newAddress = Address.new()
        newAddress.latitude = new_lat_lng[0]
        newAddress.longitude = new_lat_lng[1]
        newAddress.addressable = self
        newAddress.save
        # byebug
        self.current_address = newAddress

        # byebug
      end
      # byebug
      save!
    end

    def next_status
      if free_moving?
        free_stationary!
      elsif heading_to_pickup?
        waiting_for_pickup!
      elsif heading_to_drop_off?
        order.awaiting_customer_pickup!
        waiting_for_drop_off!
        # order.save!
      end
      save!
    end

end
