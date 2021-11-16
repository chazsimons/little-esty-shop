class BulkDiscount < ApplicationRecord
  belongs_to :merchant
  validates :percentage, numericality: { less_than_or_equal_to: 0.95,  only_float: true }
  validates :threshold, numericality: true
end
