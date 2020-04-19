require 'rails_helper'

describe Item, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :price }
    it { should validate_presence_of :inventory }

  end

  describe "relationships" do
    it {should belong_to :merchant}
    it {should have_many :reviews}
    it {should have_many :item_orders}
    it {should have_many(:orders).through(:item_orders)}
  end

  describe "instance methods" do
    before(:each) do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @chain = @bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)

      @review_1 = @chain.reviews.create(title: "Great place!", content: "They have great bike stuff and I'd recommend them to anyone.", rating: 5)
      @review_2 = @chain.reviews.create(title: "Cool shop!", content: "They have cool bike stuff and I'd recommend them to anyone.", rating: 4)
      @review_3 = @chain.reviews.create(title: "Meh place", content: "They have meh bike stuff and I probably won't come back", rating: 1)
      @review_4 = @chain.reviews.create(title: "Not too impressed", content: "v basic bike shop", rating: 2)
      @review_5 = @chain.reviews.create(title: "Okay place :/", content: "Brian's cool and all but just an okay selection of items", rating: 3)
    end

    it "calculate average review" do
      expect(@chain.average_review).to eq(3.0)
    end

    it "sorts reviews" do
      top_three = @chain.sorted_reviews(3,:desc)
      bottom_three = @chain.sorted_reviews(3,:asc)

      expect(top_three).to eq([@review_1,@review_2,@review_5])
      expect(bottom_three).to eq([@review_3,@review_4,@review_5])
    end

    it 'can_be_fulfilled' do
      expect(@chain.can_be_fulfilled(4)).to eq(true)
    end

    it 'no orders' do
      expect(@chain.no_orders?).to eq(true)
      user = User.create(name: "David", address: "123 Test St", city: "Denver", state: "CO", zip: "80204", email: "123@example.com", password: "password", role: 1)
      order = user.orders.create(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      order.item_orders.create(item: @chain, price: @chain.price, quantity: 2)
      expect(@chain.no_orders?).to eq(false)
    end

    it "sorts 5 most/least popular items" do
      bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      #bike_shop items
      tire = bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      rim = bike_shop.items.create(name: "Shiny Wheel", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      tire_parts = bike_shop.items.create(name: "Parts for Wheels", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      axle = bike_shop.items.create(name: "Wheel Axle", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      seat = bike_shop.items.create(name: "Bike Seat", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

      #dog_shop items
      pull_toy = dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      dog_bone = dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", status: false, inventory: 21)
      chew_rope = dog_shop.items.create(name: "Chew Rope", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", status: false, inventory: 21)
      squeaky_toy = dog_shop.items.create(name: "Squeaky Toy", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", status: false, inventory: 21)
      kong_toy = dog_shop.items.create(name: "Kong Toy", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", status: false, inventory: 21)
      user = User.create(name: "David", address: "123 Test St", city: "Denver", state: "CO", zip: "80204", email: "123@example.com", password: "password", role: 1)


      order1 = user.orders.create(id: 3, name: "Colin", address: "400 Wash", city: "Denver", state: "CO", zip: 80203)

      item_order1 = ItemOrder.create(order_id: order1.id, item: pull_toy, quantity: 1, price: pull_toy.price)
      item_order2 = ItemOrder.create(order_id: order1.id, item: dog_bone, quantity: 2, price: dog_bone.price)
      item_order3 = ItemOrder.create(order_id: order1.id, item: tire, quantity: 3, price: tire.price)
      item_order4 = ItemOrder.create(order_id: order1.id, item: rim, quantity: 4, price: rim.price)
      item_order5 = ItemOrder.create(order_id: order1.id, item: chew_rope, quantity: 5, price: chew_rope.price)
      item_order6 = ItemOrder.create(order_id: order1.id, item: squeaky_toy, quantity: 6, price: squeaky_toy.price)

      expect(Item.most_popular.to_a).to eql([squeaky_toy, chew_rope, rim, tire, dog_bone])

      expect(Item.least_popular.to_a).to eql([pull_toy, dog_bone, tire, rim, chew_rope])
    end

    it "sets a default photo value if there is none" do
      bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      tire = bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "", inventory: 12)
      rim = bike_shop.items.create(name: "Shiny Wheel", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

      tire.default_photo?
      expect(tire.image). to eql("https://dapp.dblog.org/img/default.jpg")
      expect(rim.image).to eql(rim.image)
    end

    it "#apply_discount calculate the discounted_price based on the discount passed" do
      bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 23137)
      discount_1 = bike_shop.discounts.create(quantity: 5, percentage: 50)
      rim = bike_shop.items.create(name: "Rim", description: "Strong spokes.", price: 10, image: "https://cdn10.bigcommerce.com/s-6w6qcuo4/product_images/attribute_rule_images/19719_zoom_1516397191.jpg", inventory: 30)

      rim.apply_discount(discount_1)
      expect(rim.discounted_price).to eq(5.0)
    end
  end
end
