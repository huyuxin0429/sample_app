require_relative  "drone_handler"
include DroneHandler
# require 'drone_handler'
require 'clockwork'
include Clockwork

require  'rake'

#   



every(DroneHandler.timeDelta.seconds, 'Run simulation') do
    Rake::Task['run_simulator:drone_sim'].invoke
end