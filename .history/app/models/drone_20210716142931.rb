class Drone < ApplicationRecord
  has_one :order
  has_one :current_address, class_name: "Address", as: :addressable, dependent: :destroy 
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
        
      end
    end
    save!
    if changed
      destination_address = Address.find(destination_address_id)
      address_routes = address_id_route.map{ |id|
        Address.find(id)
      }
      # output_json = self.to_json + self.current_address.to_json + destination_address.to_json
      output_hash = {
        drone: self, 
        drone_curr_address: self.current_address, 
        drone_destination_address: destination_address,
        drone_address_route: address_routes
      
      }
      ActionCable.server.broadcast 'drone_channel', output_hash.to_json

      ActionCable.server.broadcast "drone_channel_user_#{self.order.customer_id}", output_hash.to_json

      ActionCable.server.broadcast "drone_channel_user_#{self.order.merchant_id}", output_hash.to_json

      puts output_hash.to_json

      if order.completed?
        order.drone = nil
        self.order = nil
      end


      # ActionCable.server.broadcast "drone_channel_user#{order.customer_id}", self.to_json
      # ActionCable.server.broadcast "drone_channel_user#{order.merchant_id}", self.to_json
    end
    
  end

  def deliver(order)
    self.order = order
    nearestStaionAddress2me = Address.where(addressable_type: "Station").near(current_address, 50, units: :km).first
    nearestStation2me = nearestStaionAddress2me.addressable
    merchant_addresss = Address.find(order.pick_up_address_id)
    nearestStaionAddress2merchant = Address.where(addressable_type: "Station").near(merchant_addresss, 50, units: :km).first
    nearestStation2merchant = nearestStaionAddress2merchant.addressable
    cust_address = Address.find(order.drop_off_address_id)
    nearestStaionAddress2cust = Address.where(addressable_type: "Station").near(cust_address, 50, units: :km).first
    nearestStation2cust = nearestStaionAddress2cust.addressable

    address_id_route = GraphModules.path_address_id(nearestStation2me.provided_id, nearestStation2merchant.provided_id)
    address_id_route << merchant_addresss.id
    address_id_route = address_id_route.concat GraphModules.path_address_id(nearestStation2merchant.provided_id, nearestStation2cust.provided_id)
    address_id_route << cust_address.id
    address_id_route << nearestStaionAddress2cust.id

    self.address_id_route = address_id_route

    byebug

    self.destination_address_id = address_id_route[0]
    # byebug
    heading_to_pickup!
    self.save!
    byebug
    
  end

  private

    def approach(target_id, time_delta)
      if target_id == current_address.id
        return 
      end
      # byebug
      target_address = Address.find(target_id)


      curr_distance = Geocoder::Calculations.distance_between(self.current_address, target_address)
      new_distance = speed * time_delta

      
      # byebug
      if (curr_distance < new_distance)
        self.current_address = target_address.deep_copy
        self.current_address.save!
        address_id_route = address_id_route[1..]
        if target_address.addressable_type != "station"
          next_status
        else
          if !address_id_route[0].nil?
            destination_address_id = address_id_route[0]
          else
            if free_moving?
              next_status
            end
            destination_address_id = current_address.id
          end
        end
        
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
