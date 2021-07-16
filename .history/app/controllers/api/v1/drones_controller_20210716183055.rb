class Api::V1::DronesController < Api::V1::BaseController
    before_action :admin_user_filter, only: [:index, :show]

    def setDroneSpeed
        speed = droneParams[:droneSpeed]
        DroneHandler.setDroneSpeed(speed)
    end

    def setDroneNumber
        number = droneParams[:droneNumber]
        DroneHandler.setDroneNumber(number)
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
            render json: { error: "drone does not exist." }, status: 400
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
