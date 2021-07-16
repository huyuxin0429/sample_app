class Api::V1::DronesController < Api::V1::BaseController
    before_action :admin_user_filter, only: [:index, :show]

    def recalculate
        GraphModules.all_pairs_shortest_paths
        path = Setting.shortest_paths
        next_station = Setting.next
        render json: { message: "Path recalculated", path: path, next: next_station }, status: 200
    end

    def setDroneSpeed
        speed = droneParams[:droneSpeed]
        DroneHandler.setDroneSpeed(speed)
        render json: { message: "Drone speed changed" }, status: 200
    end

    def setDroneNumber
        number = droneParams[:droneNumber]
        DroneHandler.setDroneNumber(number)
        render json: { message: "Drone number changed" }, status: 200
    end

    def index
        @drones = Drone.all 
        render json: @drones
    end

    def show
        @drone = Drone.find_by(id: params[:id])

        if @drone
            render json: @drone, include:
            [:order]
        else
            render json: { error: "Drone does not exist." }, status: 400
        end
    end

    private
        def droneParams
            params.permit(
                :droneSpeed,
                :droneNumber
            )
        end

end
