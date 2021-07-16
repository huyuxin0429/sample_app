class Api::V1::HealthController < ApplicationController
  def index
    render json: { status: 'online' }, status: 200
  end
end
