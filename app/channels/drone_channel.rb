class DroneChannel < ApplicationCable::Channel
  def subscribed
    stop_all_streams
    # stream_from "some_channel"
    stream_from "drone_channel"
    # stream_from "drone_channel_user#{current_user.id}"
  end

  def unsubscribed
    stop_all_streams
    # Any cleanup needed when channel is unsubscribed
  end
end
