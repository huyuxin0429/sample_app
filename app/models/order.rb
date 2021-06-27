class Order < ApplicationRecord
    belongs_to :customer
    belongs_to :merchant
    belongs_to :drone, optional: true
    has_many :order_entries
    has_many :products, through: :order_entries

    validate :all_order_entries_are_from_same_merchant
    # validate :all_order_entries_prices_add_up_to_total_price
    # validates :total_price, presence: true, numericality: {}
    validates :order_entries, :length => { :minimum => 1 }
    validates :pick_up_address_id, presence: true
    validates :drop_off_address_id, presence: true
    validate :customer_contains_drop_off_address
    validate :merchant_contains_pick_up_address
    before_save :calculate_total_price
    # before_save :add_to_drone_order_queue

    # def add_to_drone_order_queue
    #     DroneHandler.addOrderToDroneQueue(self)
    # end


    scope :waiting_order, ->() {
        where(status: "merchant_preparing").where(drone: nil)
    }
    def progress
        if merchant_preparing? 
            awaiting_drone_pickup!
        elsif awaiting_drone_pickup? && drone.waiting_for_pickup?
            enroute_to_customer!
        elsif enroute_to_customer? 
            awaiting_customer_pickup!
        elsif awaiting_customer_pickup? 
            completed!
            # self.drone = nil
        end
        save!
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
                # byebug
                errors.add( :drop_off_address_id ,"invalid")
            end
        end
    end

    def merchant_contains_pick_up_address
        if merchant
            found = false
            merchant.addresses.each{|address|
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
                sum += order_entry.product.price * order_entry.units_bought
            }
            self.total_price = sum
        end
end
