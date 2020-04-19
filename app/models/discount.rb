class Discount < ApplicationRecord
  validates_presence_of :name
  validates_numericality_of :quantity, only_integer: true, greater_than: 0
  validates_numericality_of :percentage, only_integer: true, greater_than: 0, less_than_or_equal_to: 100
  belongs_to :merchant
end
