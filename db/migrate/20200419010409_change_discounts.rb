class ChangeDiscounts < ActiveRecord::Migration[5.1]
  def change
    remove_column :discounts, :applied, :boolean, default: false
    add_column :discounts, :name, :string
  end
end
