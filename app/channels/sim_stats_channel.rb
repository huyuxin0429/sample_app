include SimStats

class SimStatsChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stop_all_streams
    # stream_from "some_channel"
    # stream_from "order_channel"
    # stream_from "order_channel#{current_user.id}"

    if current_user
      if current_user.admin?
        stream_from "sim_stats_channel"
      end
    end
  end

  def request

    if current_user.admin?
      SimStats.sendData
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
