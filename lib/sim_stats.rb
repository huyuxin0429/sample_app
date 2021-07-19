module SimStats
    class << self
        @@deliveryCount = 0
        @@totalDeliveryTime = 0
        @@simulationStartTime = 0
        @@initalized = false
        @@droneTransitTime = 0
        @@droneTransitCount = 0

        @@droneStartDeliveryTime = {}

        def droneStartDelivery(drone)
            @@droneStartDeliveryTime[drone.id] = timeNow
        end

        def droneReachMerchant(drone)
            @@droneTransitTime += (timeNow - @@droneStartDeliveryTime[drone.id])
            @@droneTransitCount += 1

        end

        def timeNow
            Time.current.to_i
        end

        def initialize 
            @@initialized = true
            @@simulationStartTime = timeNow
        end


        def sendData

            output_hash = {
                deliveryCount: @@deliveryCount,
                avgTimePerDelivery: @@deliveryCount == 0 ? 0 : @@totalDeliveryTime/@@deliveryCount,
                noFreeDrones: Drone.free.count,
                deliveriesCompletedLastHour: Order.where(status: "completed").where(updated_at: (1.hours.ago)..Time.now ).count,
                avgDroneTransitTime: @@droneTransitCount == 0 ? 0 : @@droneTransitTime/@@droneTransitCount,
                outstandingOrdersCount: Order.outstandingOrders.count,
                ordersNotAssgined: Order.waiting_order.count
            }
            ActionCable.server.broadcast "sim_stats_channel", output_hash.to_json

        end

        def completeDelivery(order)
            timeTaken = timeNow - order.created_at.to_i
            @@totalDeliveryTime += timeTaken
            @@deliveryCount += 1


        end
    end
    
end