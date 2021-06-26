module DroneHandler
    @@orderQueue = Queue.new
    
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
end