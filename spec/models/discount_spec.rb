require 'rails_helper'

describe Discount do
  describe "validations" do
    it { should validate_numericality_of(:quantity).only_integer }
    it { should validate_numericality_of(:percentage).only_integer }
  end

  describe "relationships" do
    it { should belong_to :merchant }
  end

  describe "methods" do
    it "#discount_applied? Returns true or false if any items in the cart are eligible for a discount" do
      bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 23137)
      bike_shop.discounts.create(quantity: 5, percentage: 50)
      rim = bike_shop.items.create(name: "Rim", description: "Strong spokes.", price: 10, image: "https://cdn10.bigcommerce.com/s-6w6qcuo4/product_images/attribute_rule_images/19719_zoom_1516397191.jpg", inventory: 30)

      cart = Cart.new({rim.id => 4})
      expect(cart.discount_applied?).to eq(false)
      cart = Cart.new({rim.id => 5})
      expect(cart.discount_applied?).to eq(true)
    end

    it "#apply_discount finds the optimal discounted price" do
      bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 23137)
      bike_shop.discounts.create(quantity: 5, percentage: 50)
      bike_shop.discounts.create(quantity: 5, percentage: 25)
      rim = bike_shop.items.create(name: "Rim", description: "Strong spokes.", price: 10, image: "https://cdn10.bigcommerce.com/s-6w6qcuo4/product_images/attribute_rule_images/19719_zoom_1516397191.jpg", inventory: 30)

      cart = Cart.new({rim.id => 5})
      cart.apply_discount(rim)
      expect(rim.discounted_price).to eq(5)
    end

    it "#discounted_subtotal calculates the total of an item based on quantity if a discount is applied" do
      bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 23137)
      discount_1 = bike_shop.discounts.create(quantity: 5, percentage: 50)
      rim = bike_shop.items.create(name: "Rim", description: "Strong spokes.", price: 10, image: "https://cdn10.bigcommerce.com/s-6w6qcuo4/product_images/attribute_rule_images/19719_zoom_1516397191.jpg", inventory: 30)

      cart = Cart.new({"#{rim.id}" => 5})
      expect(cart.discounted_subtotal(rim)).to eq(25)
    end

    it "#discounted_total calculates the total of the cart with applied discounts" do
      bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 23137)
      discount_1 = bike_shop.discounts.create(quantity: 5, percentage: 50)
      rim = bike_shop.items.create(name: "Rim", description: "Strong spokes.", price: 10, image: "https://cdn10.bigcommerce.com/s-6w6qcuo4/product_images/attribute_rule_images/19719_zoom_1516397191.jpg", inventory: 30)
      axle = bike_shop.items.create(name: "Handle Grips", description: "Keep on hangin' on.", price: 20, image: "https://images.amain.com/images/large/bikes/pnw-components/lga25tb.jpg?width=950", inventory: 12)

      cart = Cart.new({"#{rim.id}" => 5, "#{axle.id}" => 4})
      rim.apply_discount(discount_1)
      expect(cart.discounted_total).to eq(105)
    end
  end
end
