class Api::V1::EdgesController < Api::V1::BaseController
    before_action :admin_user_filter, only: [:destroy, :index, :create, :show]

    def referredStation
        station_id = params[:station_id]
        Station.find_by(id: station_id)
    end

    def index
        @edges = referredStation.edges.all 
        render json: @edges
    end

    def show
        @edge = referredStation.edges.find_by(id: params[:id])


        if @edge
            render json: @edge
        else
            render json: { error: "Edge does not exist." }, status: 400
        end
    end

    class EdgeError < StandardError
        attr_reader :detailed_message
        
        def initialize(detailed_message='')
            super
            @detailed_message = detailed_message
        end

        def message
            "Error while creating edge"
        end
    end

    def create
        begin
            if Station.find_by(id: edge_params[:src_id]).nil? ||
                Station.find_by(id: edge_params[:dest_id]).nil?
    
                raise EdgeError.new("Provided source id/provided destination id invalid")
            end
    
    
            if !Edge.where(src_id: edge_params[:src_id]).where(
                dest_id: edge_params[:dest_id]
            ).first.nil?
                raise EdgeError.new("Edge already exists")
            end
    

            edge = Edge.new()
            edge.src_id = edge_params[:src_id]
            edge.dest_id = edge_params[:dest_id]
            src_station = Station.find_by(id: edge_params[:src_id])
            dest_station = Station.find_by(id: edge_params[:dest_id])
            edge.cost = src_station.address.distance_to(dest_station.address)
            edge << src_station
            edge << dest_station
            edge.save!
            render json: { message: "Edge created"}, status: 201
            
        rescue EdgeError => error
            render json: { message: error.message, details: error.detailed_message  }, status: 400
        else
            render json: { message: "Edge created"}, status: 201
            
        end
      
       
    end

    def destroy
        @edge = Edge.find_by(id: params[:id])
        if @edge
            @edge.destroy
            render json: { message: "Edge destroyed"}, status: 204
        else
            render json: { error: "Edge does not exist." }, status: 400
        end
    end

    private
        def edge_params
            params.permit(
                :src_id,
                :dest_id
            )
        end
end
