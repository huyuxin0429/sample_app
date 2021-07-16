
require "#{Rails.root}/lib/SG random address generator/generate_new_address.rb"
include GenerateNewAddress
module DroneHandler


    # count  = 0
    # Rufus::Scheduler.singleton.every '10s' do
    #     puts "handler simualting count" + count.to_s
    #     count += 1
    #     simulate
    # end

    class << self
        # def addOrderToDroneQueue(order)
        #     puts'adding 2 queue'
        #     # orderAdd = Address.find(order.pick_up_address_id)
        #     # availDrones = Drone.where(status: 'free_stationary').or(Drone.where(status: 'free_stationary'))
        #     # drone = availDrones.near(orderAdd).first
        #     # drone.
        #     # drone.status = :heading_to_pickup
        #     # drone.setDestination(orderAdd)
        #     # drone
        #     $orderQueue << order
        #     byebug
        # end
    
        def setDroneNumber(num)
            Setting.drone_num = num
        end

        def getUpdatedDroneNum
            Setting.clear_cache
            Setting.drone_num
            # setting = Setting.find_or_initialize_by(var: "drone_num")
            # setting.reload
            # setting.value
        end
    
        def setDroneSpeed(speed)
            Setting.drone_speed = speed
            drones = Drone.all
            drones.each{|drone|
                drone.speed = speed
                drone.save!
            }
        end

        def timeDelta
            Setting.time_delta_in_seconds
        end

        def startSimulation()
            Setting.drone_sim_initialised = true
            setDroneSpeed(Setting.drone_speed)
        end
    
        def simulate()
            # byebug
            message = Setting.test_websocket_message
            channel = Setting.test_websocket_message_channel

            ActionCable.server.broadcast channel, message

            if !Setting.drone_sim_initialised
                startSimulation
            end
            # puts "Simulating!"
            drones = Drone.all
            drones.each{|drone|
                # puts 'test'
                drone.simulate(Setting.time_delta_in_seconds)
            }
            # puts getUpdatedDroneNum
            while Drone.all.reload.count > getUpdatedDroneNum
                # puts 'test1'
                if  !Drone.free.first.nil?
                    Drone.free.first.destroy
                else
                    break
                end
                
            end

            while Drone.all.reload.count < getUpdatedDroneNum
                customGenerated = GenerateNewAddress.new
                country =  customGenerated[0]
                postcode =  customGenerated[1]
                drone = Drone.new()
                # byebug
                result = Geocoder.search(country + ',' + postcode)[0]
                while result.nil?
                    customGenerated = GenerateNewAddress.new
                    country =  customGenerated[0]
                    postcode =  customGenerated[1]
                    result = Geocoder.search(country + ',' + postcode)[0]
                end
                # byebug
                address = Address.new(
                    latitude: result.latitude,
                    longitude: result.longitude
                )
                address.addressable = drone
                # byebug
                drone.current_address = address
                drone.save!
                address.save!

            end

            
            # byebug

            Drone.free.reload.each{ |drone|
                # byebug
                waitingOrder = Order.waiting_order.reload.first
                if waitingOrder.nil?
                    break
                end
                # byebug
                
                drone.deliver(waitingOrder)
                waitingOrder.drone = drone
                waitingOrder.save!

                
            }
    
            
        end
    end
   
end