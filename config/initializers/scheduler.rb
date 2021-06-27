require 'rufus-scheduler'
include DroneHandler

# Let's use the rufus-scheduler singleton
#
s = Rufus::Scheduler.singleton
return if defined?(Rails::Console) || Rails.env.test? || File.split($0).last == 'rake'


# Stupid recurrent task...
#
s.every '10s' do
    DroneHandler.simulate
#   Rails.logger.info "hello, it's #{Time.now}"
#   Rails.logger.flush
end