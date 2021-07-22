class Customer < User
    # has_one :identity, :class_name => "User", :foreign_key => "identifiable_id", dependent: :destroy
    
    # before_destroy :deletePrereq
    has_many :orders, dependent: :destroy

    # def deletePrereq
    #     self.orders.each { |order| 
    #         order.destroy
    #     }
    # end


end
