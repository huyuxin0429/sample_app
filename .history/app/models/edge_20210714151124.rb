class Edge < ApplicationRecord
    validates :provided_src_id, presence: true
    validates :provided_dest_id, presence: true
    validates :cost, presence: true

    has_and_belongs_to_many :stations



end
