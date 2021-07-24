module SimStats
    class << self
        # Setting.deliveryCount = 0
        # Setting.totalDeliveryTime = 0
        # Setting.simulationStartTime = 0
        # Setting.initalized = false
        # Setting.droneTransitTime = 0
        # Setting.droneTransitCount = 0

        # Setting.droneStartDeliveryTime = {}

        def droneStartDelivery(drone)
            Setting.droneStartDeliveryTime[drone.id] = timeNow
        end

        def droneReachMerchant(drone)
            Setting.droneTransitTime += (timeNow - Setting.droneStartDeliveryTime[drone.id])
            Setting.droneTransitCount += 1

        end

        def timeNow
            Time.current.to_i
        end

        def initialize 
            Setting.initialized = true
            Setting.simulationStartTime = timeNow
        end


        def sendData

            output_hash = {
                deliveryCount: Setting.deliveryCount,
                avgTimePerDelivery: Setting.deliveryCount == 0 ? 0 : Setting.totalDeliveryTime/Setting.deliveryCount,
                noFreeDrones: Drone.free.count,
                deliveriesCompletedLastHour: Order.where(status: "completed").where(updated_at: (1.hours.ago)..Time.now ).count,
                avgDroneTransitTime: Setting.droneTransitCount == 0 ? 0 : Setting.droneTransitTime/Setting.droneTransitCount,
                outstandingOrdersCount: Order.outstandingOrders.count,
                ordersNotAssigned: Order.waiting_order.count
            }
            ActionCable.server.broadcast "sim_stats_channel", output_hash.to_json

        end

        def completeDelivery(order)
            timeTaken = timeNow - order.created_at.to_i
            Setting.totalDeliveryTime += timeTaken
            Setting.deliveryCount += 1


        end
    end
    
end