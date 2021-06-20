class Customer < ApplicationRecord
    has_one :identity, as: :identifiable
end
