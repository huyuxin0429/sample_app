module DroneHandler
    $time_delta_in_seconds = 20
    $drone_num = 10
    $drone_speed = 1
    @@initialised = false


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
                drone.save!
            }
        end

        def startSimulation()
            @@initialised = true
            setDroneSpeed($drone_speed)
        end
    
        def simulate()
            if !@@initialised
                startSimulation
            end
            puts "Simulating!"
            drones = Drone.all
            drones.each{|drone|
                puts 'test'
                drone.simulate($time_delta_in_seconds)
            }
            while Drone.all.count > $drone_num
                puts 'test1'
                Drone.free.first.destroy
            end
            # byebug

            Drone.free.reload.each{ |drone|
                # byebug
                waitingOrder = Order.waiting_order.reload.first
                if waitingOrder.nil?
                    break
                end
                # byebug
                waitingOrder.drone = drone
                drone.order = waitingOrder
                drone.heading_to_pickup!
                drone.save!
                waitingOrder.save!

                
            }
    
            
        end
    end
   
end