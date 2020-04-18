class ChangeDefaultValues < ActiveRecord::Migration[5.1]
  def change
    change_column :discounts, :quantity, :integer, default: 0
    change_column :discounts, :percentage, :integer, default: 0
    change_column :discounts, :applied, :boolean, default: false
  end
end
