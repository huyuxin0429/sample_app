include DroneHandler
every(DroneHandler.timeDelta.seconds, 'Run simulation') do
    DroneHandler.simulate
end