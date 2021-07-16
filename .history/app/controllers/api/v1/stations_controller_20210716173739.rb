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

    def create
        address = Address.new(
            longitude: station_params.longitude
            latitude: station_params.latitude
        )
        station = Station.new()
        station.provided_id = station_params.provided_id
        station.addressable = address
        address.save!
        station.save!
    end

    def destroy
        @station = Station.find_by(id: params[:id])
        if @station
            @station.destroy
            render json: { message: "tation destroyed"}, status: 204
        else

        end
    end

    private
        def station_params
            params.permit(
                :latitude
                :longitude
                :provided_id
            )
        end

end
