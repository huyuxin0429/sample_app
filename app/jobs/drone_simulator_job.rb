include DroneHandler
class DroneSimulatorJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    DroneHandler.simulate
  end
end
