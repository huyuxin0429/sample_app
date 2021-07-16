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

    def create
        if !Edge.find_by(provided_id: edge_params[:provided_id]).nil?
            render json: { message: "Provided id already exists"  }, status: 400
        else
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
