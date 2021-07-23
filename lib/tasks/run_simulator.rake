namespace :run_simulator do
    desc "run drone simuation"

  task :drone_sim do
    DroneHandler.simulate
  end
end
