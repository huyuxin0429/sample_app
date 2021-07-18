module SimStats
    @@deliveryCount = 0
    @@totalDeliveryTime = 0
    @@noFreeDrones = 0
    @@simulationStartTime = 0
    @@deliveriesInPastHour = 0
    @@initalized = false
    @@lastHourTime = 0
    @@deliveriesCompletedLastHour = 0
    @@droneTransitTime = 0
    @@droneTransitCount = 0
    @@outstandingOrders = 0

    @@droneStartDeliveryTime = {}

    def droneStartDelivery(drone)
        @@droneStartDeliveryTime[drone.id] = timeNow
    end

    def droneReachMerchant(drone)
        @@droneTransitTime += (timeNow - @@droneStartDeliveryTime[drone.id])
        @@droneTransitTime += 1

    end

    def timeNow
        Time.current.to_i
    end

    def initialize 
        @@initialized = true
        @@simulationStartTime = timeNow
        @@lastHourTime = @@simulationStartTime
    end

    def idleDroneCount
        Drone.free
    end

    def evaluate
        if timeNow - @@lastHourTime > 1.hour.to_i
            @@deliveriesCompletedLastHour = 0
            @@lastHourTime = timeNow
        end

        @@outstandingOrders = Order.outstandingOrders.count

    end

    def completeDelivery(order)
        timeTaken = timeNow - order.created_at.to_i
        @@totalDeliveryTime += timeTaken
        @@deliveryCount += 1
        @@deliveriesCompletedLastHour += 1


    end
    
    
end