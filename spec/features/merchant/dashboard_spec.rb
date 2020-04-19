require 'rails_helper'

RSpec.describe 'As a merchant user on the merchant dashboard page', type: :feature do
  before(:each) do
    @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 23137)
    @merchant_user = User.create(name: "David", address: "123 Test St", city: "Denver", state: "CO", zip: "80204", email: "123@example.com", password: "password", role: 2)
    @bike_shop.add_employee(@merchant_user)
    @user = User.create(name: "Colin", address: "123 Test St", city: "Denver", state: "CO", zip: "80204", email: "123@example.com", password: "password", role: 1)
    @tire = @bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @rim = @bike_shop.items.create(name: "Rim", description: "Strong spokes.", price: 100, image: "https://cdn10.bigcommerce.com/s-6w6qcuo4/product_images/attribute_rule_images/19719_zoom_1516397191.jpg", inventory: 12)
    @dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
    @pull_toy = @dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    @dog_bone = @dog_shop.items.create(name: "Dog Bone", description: "Bonified fun!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", status: false, inventory: 21)
    @order1 = @user.orders.create(id: 3, name: "Colin", address: "400 Wash", city: "Denver", state: "CO", zip: 80203)
    @order1.item_orders.create(order_id: @order1.id, item: @tire, quantity: 1, price: @tire.price)
    @order1.item_orders.create(order_id: @order1.id, item: @rim, quantity: 2, price: @rim.price)
    @order1.item_orders.create(order_id: @order1.id, item: @pull_toy, quantity: 2, price: @pull_toy.price)
    @order2 = @user.orders.create(id: 5, name: "Colin", address: "400 Wash", city: "Denver", state: "CO", zip: 80203)
    @order2.item_orders.create(order_id: @order2.id, item: @rim, quantity: 1, price: @tire.price)
    @bike_shop.add_employee(@merchant_user)

  end
  it "I see the name and full address of the merchant I am associated with" do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_user)

    visit "/merchant"

    within '.merchant-info' do
      expect(page).to have_content(@bike_shop.name)
      expect(page).to have_content(@bike_shop.address)
      expect(page).to have_content(@bike_shop.city)
      expect(page).to have_content(@bike_shop.state)
      expect(page).to have_content(@bike_shop.zip)
    end
  end

  it "I see a list of any pending orders for items I sell, each order with an id, date made, total qty and grandtotal" do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_user)

    visit '/merchant'

    within '.merchant-orders' do
      within "#order-#{@order1.id}" do
        expect(page).to have_content(@order1.id)
        expect(page).to have_content(@order1.created_at)
        expect(page).to have_content("Merchant Items Quantity: 3")
        expect(page).to have_content("Merchant Items Cost: $300.00")
      end
      within "#order-#{@order2.id}" do
        expect(page).to have_content(@order2.id)
        expect(page).to have_content(@order2.created_at)
        expect(page).to have_content("Merchant Items Quantity: 1")
        expect(page).to have_content("Merchant Items Cost: $100.00")
      end
    end
  end

  it "I can click a link to view my own items and I am taken to that page" do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_user)

    visit '/merchant'

    click_on 'Merchant Items'

    expect(current_path).to eql('/merchant/items')
  end

  it "I can click a link to view my own items and I am taken to that page" do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_user)

    visit '/merchant'

    click_on 'Merchant Items'

    expect(current_path).to eql('/merchant/items')
  end

  it "has a link to view available discounts" do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_user)

    visit "/merchant"

    click_link("Discounts Dashboard")

    expect(current_path).to eq("/merchant/discounts")
  end
end
