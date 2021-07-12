class OrderChannel < ApplicationCable::Channel
  def subscribed
    stop_all_streams
    # stream_from "some_channel"
    stream_from "order_channel"
    # stream_from "order_channel#{current_user.id}"

    if current_user
      if current_user.admin?
        stream_from "order_channel"
      else
        stream_from "order_channel_user_#{current_user.id}"
      end
      
    end
  end

  def request

    if current_user.admin?
        orders = Order.where.not(status: "completed")
        orders.map { |order|
            {
              order: order, 
              # order_curr_address: order.current_address, 
              order_curr_address: 
                ? order.status == "merchant_preparing" || order.status == "awaiting_drone_pickup"
                : Address.find(order.pick_up_address_id)
                ? order.status == "enroute_to_customer"
                : order.drone.current_address
                ? order.status == "awaiting_customer_pickup" || order.status == "completed" 
                : Address.find(order.drop_off_address_id)
            }
        }
        ActionCable.server.broadcast "order_channel", orders.to_json


    else


      if current_user.type == "Customer"
        cust = Customer.find(current_user.id)
        orders = cust.orders.outstandingOrders
      elsif current_user.type == "Merchant"
        merc = Merchant.find(current_user.id)
        orders = merc.orders.outstandingOrders
      else
        puts 'Not customer or merchant'
        return nil
      end

      if orders.nil?
        puts 'orders not found'
        return nil
      end

      orders = order.where(order: orders).distinct
      # byebug

      # orders.map { |order|
      #   {
      #     order: order, 
      #     order_curr_address: order.current_address, 
      #     order_destination_address: Address.find(order.destination_address_id)
      #   }
      # }
      # count = 0
      orders.each { |order|
        # puts count
        destination_address = Address.find(order.destination_address_id)
        output_hash = {order: order, order_curr_address: order.current_address, order_destination_address: destination_address}
        # byebug
        ActionCable.server.broadcast "order_channel_user_#{current_user.id}", output_hash.to_json
        # count += 1
      }

      # order = orders.first
      # destination_address = Address.find(order.destination_address_id)
      # output_hash = {order: order, order_curr_address: order.current_address, order_destination_address: destination_address}
      # ActionCable.server.broadcast "order_channel_user_#{current_user.id}", orders.to_json

      # order = orders.second
      # destination_address = Address.find(order.destination_address_id)
      # output_hash = {order: order, order_curr_address: order.current_address, order_destination_address: destination_address}
      # ActionCable.server.broadcast "order_channel_user_#{current_user.id}", orders.to_json
      

    # ActionCable.server.broadcast "order_channel_user_#{current_user.id}", orders.to_json
   

  end

  def unsubscribed
    stop_all_streams
    # Any cleanup needed when channel is unsubscribed
  end
end
