class Edge < ApplicationRecord
    validates :provided_src_id, presence: true
    validates :provided_dest_id, presence: true
    validates :cost, presence: true



end
