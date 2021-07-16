class Api::V1::StationsController < Api::V1::BaseController
    def index
        @stations = Stations.all 
        render json: @stations
    end

    def show
        @station = Station.find_by(id: params[:id])

        if @station
            render json: @station, include:
            [:edges]
        else
            render json: { error: "Station does not exist." }, status: 400
        end
    end
end
