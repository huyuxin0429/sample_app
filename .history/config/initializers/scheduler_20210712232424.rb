require 'rufus-scheduler'
include DroneHandler

# Let's use the rufus-scheduler singleton
#
s = Rufus::Scheduler.singleton
return if defined?(Rails::Console) || Rails.env.test? || File.split($0).last == 'rake'


# Stupid recurrent task...

if Rails.env.production? 
    s.every DroneHandler.timeDelta.to_s + 's' do
        ActiveRecord::Base.connection_pool.with_connection do
            #your code here
            DroneHandler.simulate
        end
        
        # ActionCable.server.broadcast 'map_channel', Drone.all.to_json
    #   Rails.logger.info "hello, it's #{Time.now}"
    #   Rails.logger.flush
    end
end


if Rails.env.development? 
    s.every DroneHandler.timeDelta.to_s + 's' do
        ActiveRecord::Base.connection_pool.with_connection do
            #your code here
            DroneHandler.simulate
        end
        
        # ActionCable.server.broadcast 'map_channel', Drone.all.to_json
    #   Rails.logger.info "hello, it's #{Time.now}"
    #   Rails.logger.flush
    end
end

# s.every DroneHandler.timeDelta.to_s + 's' do
#     ActiveRecord::Base.connection_pool.with_connection do
#         #your code here
#         # DroneHandler.simulate
#     end
    
#     ActionCable.server.broadcast 'drone_channel_user_2', Drone.all.to_json
# #   Rails.logger.info "hello, it's #{Time.now}"
# #   Rails.logger.flush
# end