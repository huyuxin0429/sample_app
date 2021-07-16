class Api::V1::StationsController < Api::V1::BaseController
    before_action :admin_user_filter, only: [:destroy, :index, :create, :show]
    def index
        @stations = Station.all 
        render json: @stations, include:
        [:address]
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
        if !Station.find_by(id: station_params[:id]).nil?
            render json: { message: "Provided id already exists"  }, status: 400
        else
            address = Address.new(
                longitude: station_params[:longitude],
                latitude: station_params[:latitude]
            )
            station = Station.new()
            station.id = station_params[:id]
            station.address = address
            address.addressable = station
            station.save!
            address.save!
            render json: { message: "Station created"}, status: 201
        end
       
    end

    def destroy
        @station = Station.find_by(id: params[:id])
        if @station
            @station.destroy
            render json: { message: "Station destroyed"}, status: 204
        else
            render json: { error: "Station does not exist." }, status: 400
        end
    end

    private
        def station_params
            params.permit(
                :latitude,
                :longitude,
                :id
            )
        end

end
