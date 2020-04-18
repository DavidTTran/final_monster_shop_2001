class CreateDiscounts < ActiveRecord::Migration[5.1]
  def change
    create_table :discounts do |t|
      t.integer :quantity
      t.integer :percentage
      t.boolean :applied
    end
  end
end
