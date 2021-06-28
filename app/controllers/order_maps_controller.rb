class OrderMapsController < ApplicationController
  before_action :set_order_map, only: %i[ show edit update destroy ]

  # GET /order_maps or /order_maps.json
  def index
    @order_maps = OrderMap.all
  end

  # GET /order_maps/1 or /order_maps/1.json
  def show
  end

  # GET /order_maps/new
  def new
    @order_map = OrderMap.new
  end

  # GET /order_maps/1/edit
  def edit
  end

  # POST /order_maps or /order_maps.json
  def create
    @order_map = OrderMap.new(order_map_params)

    respond_to do |format|
      if @order_map.save
        format.html { redirect_to @order_map, notice: "Order map was successfully created." }
        format.json { render :show, status: :created, location: @order_map }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @order_map.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /order_maps/1 or /order_maps/1.json
  def update
    respond_to do |format|
      if @order_map.update(order_map_params)
        format.html { redirect_to @order_map, notice: "Order map was successfully updated." }
        format.json { render :show, status: :ok, location: @order_map }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @order_map.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /order_maps/1 or /order_maps/1.json
  def destroy
    @order_map.destroy
    respond_to do |format|
      format.html { redirect_to order_maps_url, notice: "Order map was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order_map
      @order_map = OrderMap.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def order_map_params
      params.require(:order_map).permit(:words)
    end
end
