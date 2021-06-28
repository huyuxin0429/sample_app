require_relative  "drone_handler"
include DroneHandler
# require 'drone_handler'
require 'clockwork'
include Clockwork

#   



every(DroneHandler.timeDelta.seconds, 'Run simulation') do
    DroneHandler.simulate()
end