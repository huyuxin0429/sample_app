class Api::V1::DronesController < Api::V1::BaseController
    before_action :admin_user_filter, only: [:index, :show]
    def index
        @drones = Drone.all 
        render json: @drones
    end

    def show
        @drone = Drone.find_by(id: params[:id])

        if @drone
            render json: @drone, include:
            [:edges]
        else
            render json: { error: "drone does not exist." }, status: 400
        end
    end

end
