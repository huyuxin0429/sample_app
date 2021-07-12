class DroneChannel < ApplicationCable::Channel
  def subscribed
    stop_all_streams
    # stream_from "some_channel"
    if current_user
      if current_user.admin?
        stream_from "drone_channel"
      else
        stream_from "drone_channel_user_#{current_user.id}"
      end
      
    end

    # stream_from "drone_channel"
    
  end
  
  def request

      if current_user.admin?
          drones = Drone.all
          drones.map { |drone|
              {
                drone: drone, 
                drone_curr_address: drone.current_address, 
                drone_destination_address: Address.find(drone.destination_address_id)
              }
          }
          ActionCable.server.broadcast "drone_channel", drones.to_json


      else


        if current_user.type == "Customer"
          cust = Customer.find(current_user.id)
          orders = cust.orders.outstandingOrders
        elsif current_user.type == "Merchant"
          merc = Merchant.find(current_user.id)
          orders = merc.orders.outstandingOrders
        else
          puts 'Not customer or merchant'
          return nil
        end
  
        if orders.nil?
          puts 'orders not found'
          return nil
        end
  
        drones = Drone.where(order: orders).distinct
        # byebug
  
        # drones.map { |drone|
        #   {
        #     drone: drone, 
        #     drone_curr_address: drone.current_address, 
        #     drone_destination_address: Address.find(drone.destination_address_id)
        #   }
        # }
        # count = 0
        drones.each { |drone|
          # puts count
          destination_address = Address.find(drone.destination_address_id)
          output_hash = {drone: drone, drone_curr_address: drone.current_address, drone_destination_address: destination_address}
          # byebug
          ActionCable.server.broadcast "drone_channel_user_#{current_user.id}", output_hash.to_json
          # count += 1
        }

        # drone = drones.first
        # destination_address = Address.find(drone.destination_address_id)
        # output_hash = {drone: drone, drone_curr_address: drone.current_address, drone_destination_address: destination_address}
        # ActionCable.server.broadcast "drone_channel_user_#{current_user.id}", drones.to_json

        # drone = drones.second
        # destination_address = Address.find(drone.destination_address_id)
        # output_hash = {drone: drone, drone_curr_address: drone.current_address, drone_destination_address: destination_address}
        # ActionCable.server.broadcast "drone_channel_user_#{current_user.id}", drones.to_json
        

      # ActionCable.server.broadcast "drone_channel_user_#{current_user.id}", drones.to_json
     

    end
  end

  def unsubscribed
    stop_all_streams
    # Any cleanup needed when channel is unsubscribed
  end
end
