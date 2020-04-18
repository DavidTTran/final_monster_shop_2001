class Discount < ApplicationRecord
  validates_numericality_of :quantity, :percentage, only_integer: true
  belongs_to :merchant
end
