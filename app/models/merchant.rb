class Merchant < ApplicationRecord
    has_one :identity, as: :identifiable
end
