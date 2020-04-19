require 'rails_helper'

describe "merchant discounts" do
  before(:each) do
    @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 23137)
    @merchant_user = User.create(name: "David", address: "123 Test St", city: "Denver", state: "CO", zip: "80204", email: "123@example.com", password: "password", role: 2)
    @bike_shop.add_employee(@merchant_user)
  end

  it "a merchant can create discounts" do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_user)

    visit "/merchant/discounts"
    expect(page).to have_no_content("Quantity: 10 items")
    expect(page).to have_no_content("Pecentage: 5% off")

    click_link("Create Discount")

    expect(current_path).to eq("/merchant/discounts/new")

    fill_in :name, with: "Test Discount"
    fill_in :quantity, with: 10
    fill_in :percentage, with: 5
    click_on "Create Discount"

    expect(current_path).to eq("/merchant/discounts")
    expect(page).to have_content("Name: Test Discount")
    expect(page).to have_content("Quantity: 10 items")
    expect(page).to have_content("Percentage: 5% off")
  end

  it "can't create a discount with invalid fields" do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_user)
    visit "/merchant/discounts/new"

    fill_in :name, with: "Test Discount"
    fill_in :quantity, with: "ten"
    fill_in :percentage, with: 5
    click_on "Create Discount"

    expect(page).to have_content("Quantity is not a number.")

    fill_in :name, with: "Test Discount"
    fill_in :quantity, with: 0
    fill_in :percentage, with: 101
    click_on "Create Discount"

    expect(page).to have_content("Quantity must be greater than 0 and Percentage must be less than or equal to 100.")
  end

  it "can update discounts with appropriate fields" do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_user)
    discount_1 = @bike_shop.discounts.create(name: "Test Discount", quantity: 10, percentage: 5)

    visit "/merchant/discounts"
    within(".discounts-list") do
      within("#discount-#{discount_1.id}") do
        expect(page).to have_content("Quantity: 10 items")
        expect(page).to have_content("Name: Test Discount")
        expect(page).to have_content("Percentage: 5% off")
        click_link("Update Discount")
      end
    end

    expect(current_path).to eq("/merchant/discounts/#{discount_1.id}/edit")
    expect(find_field(:quantity).value).to eq("#{discount_1.quantity}")
    expect(find_field(:percentage).value).to eq("#{discount_1.percentage}")

    fill_in :quantity, with: "twenty"
    click_on "Save Discount"
    expect(page).to have_content("Quantity is not a number.")

    fill_in :name, with: "Test Discount"
    fill_in :quantity, with: 20
    fill_in :percentage, with: 5
    click_on "Save Discount"

    expect(current_path).to eq("/merchant/discounts")
    within("#discount-#{discount_1.id}") do
      expect(page).to have_content("Quantity: 20 items")
      expect(page).to have_content("Name: Test Discount")
      expect(page).to have_content("Percentage: 5% off")
      click_link("Update Discount")
    end
  end

  it "can delete discounts" do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_user)
    discount_1 = @bike_shop.discounts.create(name: "Test Discount", quantity: 10, percentage: 5)
    discount_2 = @bike_shop.discounts.create(name: "Test Discount", quantity: 20, percentage: 10)

    visit "/merchant/discounts"
    within(".discounts-list") do
      within("#discount-#{discount_1.id}") do
        click_link("Remove Discount")
      end
    end

    expect(current_path).to eq("/merchant/discounts")
    expect(page).to have_no_content("Quantity: 10 items")
    expect(page).to have_no_content("Percentage: 5% off")
    expect(page).to have_content("Quantity: 20 items")
    expect(page).to have_content("Percentage: 10% off")
  end

  it "automatically applies to items that equal or are greater than the quantity" do
    @bike_shop.discounts.create(name: "Test Discount", quantity: 5, percentage: 50)
    @bike_shop.discounts.create(name: "6 Items required", quantity: 6, percentage: 90)
    rim = @bike_shop.items.create(name: "Rim", description: "Strong spokes.", price: 10, image: "https://cdn10.bigcommerce.com/s-6w6qcuo4/product_images/attribute_rule_images/19719_zoom_1516397191.jpg", inventory: 30)
    user = User.create(name: "User(Colin)", address: "123 Test St", city: "New York", state: "NY", zip: "80204", email: "user@example.com", password: "password_regular", role: 1)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    visit "/items/#{rim.id}"
    click_on "Add To Cart"
    visit "/cart"
    click_on "+1"
    click_on "+1"
    click_on "+1"
    expect(page).to have_content("Total: $40.00")
    click_on "+1"
    expect(page).to have_content("Total: $25.00")
  end

  it "removes the discount if the quantity drop below the discount_quantity" do
    @bike_shop.discounts.create(name: "Test Quantity", quantity: 5, percentage: 50)
    @bike_shop.discounts.create(name: "6 Items Required", quantity: 6, percentage: 90)
    rim = @bike_shop.items.create(name: "Rim", description: "Strong spokes.", price: 10, image: "https://cdn10.bigcommerce.com/s-6w6qcuo4/product_images/attribute_rule_images/19719_zoom_1516397191.jpg", inventory: 30)
    user = User.create(name: "User(Colin)", address: "123 Test St", city: "New York", state: "NY", zip: "80204", email: "user@example.com", password: "password_regular", role: 1)
    seat = @bike_shop.items.create(name: "Bike Seat", description: "Squishy tushy.", price: 100, image: "https://www.sefiles.net/images/library/zoom/planet-bike-little-a.r.s-bike-seat-231296-1-19-9.jpg", inventory: 17)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    visit "/items/#{rim.id}"
    click_on "Add To Cart"
    visit "/cart"
    click_on "+1"
    click_on "+1"
    click_on "+1"
    within("#total") do
      expect(page).to have_content("Total: $40.00")
    end

    click_on "+1"
    within("#total") do
      expect(page).to have_content("Total: $25.00")
    end

    visit "/items/#{seat.id}"
    click_on "Add To Cart"

    visit "/cart"
    within("#total") do
      expect(page).to have_content("Total: $125.00")
    end

    within("#cart-item-#{rim.id}") do
      click_on "-1"
    end

    within("#total") do
      expect(page).to have_content("Total: $140.00")
    end

  end
end
