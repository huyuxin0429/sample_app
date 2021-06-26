module DroneHandler
    $time_delta_in_seconds = 20
    $drone_num = 10
    $drone_speed = 1
    @@orderQueue = Queue.new
    class << self
        def addOrderToDroneQueue(order)
            # orderAdd = Address.find(order.pick_up_address_id)
            # availDrones = Drone.where(status: 'free_stationary').or(Drone.where(status: 'free_stationary'))
            # drone = availDrones.near(orderAdd).first
            # drone.
            # drone.status = :heading_to_pickup
            # drone.setDestination(orderAdd)
            # drone
            @@orderQueue << order
        end
    
        def setDroneNumber(num)
            $drone_num = num
            count = Drone.all.count
            while count < num 
                customGenerated = GenerateNewAddress.new
                country =  customGenerated[0]
                postcode =  customGenerated[1]
                drone = Drone.create!()
                address = Address.new(
                    country: country,
                    postcode: postcode
                )
                address.addressable = drone
                drone.current_address = address
                address.save!
            end
        end
    
        def setDroneSpeed(speed)
            drones = Drone.all
            drones.each{|drone|
                drone.speed = speed
            }
        end
    
        def simulate()
            puts "Simulating!"
            drones = Drone.all
            drones.each{|drone|
                drone.simulate($time_delta_in_seconds)
            }
            while count > drone_num 
                Drone.find_by(is_free?).destroy
            end
            Drone.where(is_free?).each{ |drone|
                drone.deliver(@@orderQueue.pop)
            }
    
            
        end
    end
   
end