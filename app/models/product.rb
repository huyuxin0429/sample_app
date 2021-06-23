class Product < ApplicationRecord
    belongs_to :merchant
    validates :name, presence: true
    validates :price, presence: true
    validates :quantity, presence: true
    validates :merchant_id, presence: true
    validates_uniqueness_of :name, :scope => [:merchant_id]
    has_one_attached :image

    validates :image, content_type: { in: %w[image/jpeg /image/gif image/png],
        message: "must be a valid image format"},
        size: { less_than: 5.megabytes, 
        message: "should be less than 5MB" }
    # validates :description

    def display_image
        image.variant(resize_to_limit: [500, 500])
    end
end
