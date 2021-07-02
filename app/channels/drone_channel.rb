class DroneChannel < ApplicationCable::Channel
  def subscribed
    stop_all_streams
    # stream_from "some_channel"
    if current_user
      if current_user.admin?
        stream_from "drone_channel"
      else
        stream_from "drone_channel_user_#{current_user.id}"
      end
      
    end
    
  end

  def unsubscribed
    stop_all_streams
    # Any cleanup needed when channel is unsubscribed
  end
end
