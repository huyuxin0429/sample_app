class Api::V1::HealthController < Api::V1::BaseController
  def index
    render json: { status: 'online' }, status: 200
  end
end
