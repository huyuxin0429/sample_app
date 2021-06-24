class OrderEntry < ApplicationRecord
    belongs_to :order
    belongs_to :product

    validates :units_bought, numericality: { :greater_than  => 0, only_integer: true }
    validate :product_price_times_units_bought_is_total_sum
    # validates :total_unit_price, numericality: {}
    # before_save :calculate_total_unit_price


    def product_price_times_units_bought_is_total_sum
        if !product.nil? && !units_bought.nil? && !total_unit_price.nil?
            if product.price * units_bought != total_unit_price
                errors.add(:total_unit_price, "does not add up")
            end
        end
        
    end

    private

        def calculate_total_unit_price
            # byebug
            self.total_unit_price = product.price * units_bought
        end
end
