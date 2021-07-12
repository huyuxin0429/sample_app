class Order < ApplicationRecord
    belongs_to :customer
    belongs_to :merchant
    belongs_to :drone, optional: true
    has_many :order_entries
    has_many :products, through: :order_entries

    validate :all_order_entries_are_from_same_merchant
    # validate :all_order_entries_prices_add_up_to_total_price
    validates :total_price, presence: true, numericality: {}
    validates :order_entries, :length => { :minimum => 1 }
    validates :pick_up_address_id, presence: true
    validates :drop_off_address_id, presence: true
    validate :customer_contains_drop_off_address
    validate :merchant_contains_pick_up_address
    before_save :calculate_total_price
    before_save :broadcast
    
    # before_save :add_to_drone_order_queue

    # def add_to_drone_order_queue
    #     DroneHandler.addOrderToDroneQueue(self)
    # end

    scope :outstandingOrders, ->() {
        where.not(status: "completed")
    }


    scope :waiting_order, ->() {
        where(status: "merchant_preparing").or(where(status: "awaiting_drone_pickup")).where(drone: nil)
    }

    def status2Address() 
        if status == "merchant_preparing" || status == "awaiting_drone_pickup"
          return Address.find(order.pick_up_address_id)
        elsif (status == "enroute_to_customer")
          return order.drone.current_address
        elsif (status == "awaiting_customer_pickup" || status == "completed" )
          return Address.find(order.drop_off_address_id)
        end
    end
      

    def progress
        if merchant_preparing? 
            merchant_load_order
        elsif awaiting_drone_pickup? && drone && drone.waiting_for_pickup?
            # byebug
            enroute_to_customer!
        elsif enroute_to_customer? && drone.waiting_for_drop_off?
            awaiting_customer_pickup!
        elsif awaiting_customer_pickup?  && drone.waiting_for_drop_off?
            customer_unload_order
            # self.drone = nil
        end

        output_hash =  {
            order: this, 
            # order_curr_address: order.current_address, 
            order_curr_address: status2Address()
          }
        ActionCable.server.broadcast 'order_channel', output_hash.to_json

      ActionCable.server.broadcast "order_channel_user_#{self.order.customer_id}", output_hash.to_json

      ActionCable.server.broadcast "order_channel_user_#{self.order.merchant_id}", output_hash.to_json
        # save!
    end

    def merchant_load_order
        # byebug
        awaiting_drone_pickup!
        # byebug
        # broadcast
        # save!
    end

    def customer_unload_order
        completed!
        # broadcast
        # save!
    end
        
        

    def save_broadcast
        if status_changed?
            broadcast
        end
    end

    def broadcast
        ActionCable.server.broadcast 'order_channel', self.to_json
    end


    enum status: { 
        merchant_preparing: "merchant_preparing", 
        awaiting_drone_pickup: "awaiting_drone_pickup", 
        enroute_to_customer: "enroute_to_customer",
        awaiting_customer_pickup: "awaiting_customer_pickup", 
        completed: "completed"
      }


    def all_order_entries_are_from_same_merchant
        order_entries.each{ |order_entry| 
            if order_entry.product.merchant != merchant
                errors.add(:order_entry, "must be from the same merchant")
            end
        }
    end

    # def all_order_entries_prices_add_up_to_total_price
    #     sum = 0
    #     order_entries.each{ |order_entry| 
    #         sum += order_entry.total_unit_price
    #     }
    #     if sum != total_price
    #         errors.add(:total_price, "does not add up")
    #     end
    # end

    def customer_contains_drop_off_address
        if customer
            found = false
            customer.addresses.each{|address|
                # byebug
                if address.id == drop_off_address_id
                    found = true
                    break
                end
            }
            if !found
                byebug
                errors.add( :drop_off_address_id ,"invalid")
            end
        end
    end

    def merchant_contains_pick_up_address
        if merchant
            found = false
            merchant.addresses.each{|address|
                # byebug
                if address.id == pick_up_address_id
                    found = true
                    break
                end
            }
            if !found
                # byebug
                errors.add(:pick_up_address_id,"invalid")
            end
        end
    end

    private
        def calculate_total_price
            sum = 0
            order_entries.each{ |order_entry| 
                sum += order_entry.total_unit_price
            self.total_price = sum
        end
end
