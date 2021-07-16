class Api::V1::EdgesController < Api::V1::BaseController
    before_action :admin_user_filter, only: [:destroy, :index, :create, :show]
    def index
        @edges = Edge.all 
        render json: @edges
    end

    def show
        @edge = Edge.find_by(provided_id: params[:id])

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
            "Error while creatingEdge"
        end
    end

    def create
        begin
            if Station.find_by(provided_id: edge_params[:provided_src_id]).nil? ||
                Station.find_by(provided_id: edge_params[:provided_dest_id]).nil?
    
                raise EdgeError.new("Either provided src if or provided dest id is invalid")
            end
    
    
            if !Edge.where(provided_src_id: edge_params[:provided_src_id]).where(
                provided_dest_id: edge_params[:provided_dest_id]
            ).first.nil?
                raise EdgeError.new("Edge already exists")
            end
    
            
            address = Address.new(
                longitude: edge_params[:longitude],
                latitude: edge_params[:latitude]
            )
            edge = Edge.new()
            edge.provided_id = edge_params[:provided_id]
            edge.address = address
            address.addressable = edge
            edge.save!
            address.save!
            render json: { message: "Edge created"}, status: 201
            
        rescue EdgeError => exception
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
                :provided_src_id,
                :provided_dest_id
            )
        end
end
