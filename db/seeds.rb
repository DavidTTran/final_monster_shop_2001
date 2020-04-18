ItemOrder.destroy_all
Merchant.destroy_all
Item.destroy_all
Order.destroy_all
User.destroy_all
ItemOrder.destroy_all

#merchants
bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Lincoln', state: 'WY', zip: 80203)
dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Charlesville', state: 'MS', zip: 80210)
tires_shop = Merchant.create(name: "Tires 'R Us", address: '234 Plastic St.', city: 'Houston', state: 'TX', zip: 80204)
misc_shop = Merchant.create(name: "Bargin Bin", address: '125 Wolff St.', city: 'Denver', state: 'CO', zip: 80203)
dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
temp_shop = Merchant.create(name: "This Shop Should Have No Items", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

#temp_shop items
temp = temp_shop.items.create(name: "Temp", description: "Temp", price: 55, image: "https://c-static.smartphoto.com/structured/repositoryimage/productcategory/fun_ideas/magic_mug/material/0002/image/material.jpg", inventory: 0, status: false)

#tires_shop items
tire = tires_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 75, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 20)

#misc_shop items
tire_parts = misc_shop.items.create(name: "Helmet", description: "Protect the noggin'.", price: 10, image: "https://dks.scene7.com/is/image/GolfGalaxy/17BELAPRMSXXXXXXXDLT_Matte_Black_Gunmetal?wid=2000&fmt=pjpeg", inventory: 15)
chips = misc_shop.items.create(name: "Chips", description: "Hot and Spicy", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/91GSJSJbWCL._SY550_PIbundle-3,TopRight,0,0_SX416SY550SH20_.jpg", inventory: 100)

#bike_shop items
rim = bike_shop.items.create(name: "Rim", description: "Strong spokes.", price: 25, image: "https://cdn10.bigcommerce.com/s-6w6qcuo4/product_images/attribute_rule_images/19719_zoom_1516397191.jpg", inventory: 30)
axle = bike_shop.items.create(name: "Handle Grips", description: "Keep on hangin' on.", price: 22, image: "https://images.amain.com/images/large/bikes/pnw-components/lga25tb.jpg?width=950", inventory: 12)
seat = bike_shop.items.create(name: "Bike Seat", description: "Squishy tushy.", price: 14, image: "https://www.sefiles.net/images/library/zoom/planet-bike-little-a.r.s-bike-seat-231296-1-19-9.jpg", inventory: 17)

#dog_shop items
pull_toy = dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 25)
dog_bone = dog_shop.items.create(name: "Dog Bone", description: "Bonified fun!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", status: false, inventory: 30)
chew_rope = dog_shop.items.create(name: "Chew Rope", description: "Laffy Lasso", price: 32, image: "https://ae01.alicdn.com/kf/HTB1G1JIMXXXXXa8XVXXq6xXFXXXv/Free-Shipping-Cotton-Rope-Pet-Dog-toy-Multicolor-For-Puppy-Double-Knot-Chew-Toy-Durable-Braided.jpg", inventory: 54)
squeaky_toy = dog_shop.items.create(name: "Squeaky Toy", description: "Dogs love it. Humans hate it.", price: 9, image: "https://i.pinimg.com/originals/90/7e/13/907e138fc1e8401dcedabb795d07fd67.jpg", inventory: 32)
kong_toy = dog_shop.items.create(name: "Kong Toy", description: "They paid us to say that.", price: 26, image: "https://www.dogtuff.com/media/catalog/product/cache/e4d64343b1bc593f1c5348fe05efa4a6/k/o/kong_classic_red_xxl_pkg.jpg", inventory: 50)

#users
user = User.create(name: "User(Colin)", address: "123 Test St", city: "New York", state: "NY", zip: "80204", email: "user@example.com", password: "password_regular", role: 1)
user_2 = User.create(name: "User(David)", address: "523 Test St", city: "Colorado Springs", state: "CO", zip: "80020", email: "user1@example.com", password: "password_regular", role: 1)
merchant = User.create(name: "Merchant(Max)", address: "123 Test St", city: "Houston", state: "TX", zip: "80204", email: "merchant@example.com", password: "password_merchant", role: 2)
admin = User.create(name: "Admin(Kevin)", address: "123 Test St", city: "Fable", state: "WA", zip: "80204", email: "admin@example.com", password: "password_admin", role: 3)
admin_2 = User.create(name: "Admin(Louis)", address: "123 Test St", city: "Denver", state: "CO", zip: "80204", email: "admin2@example.com", password: "password_admin", role: 3)

merchant_1 = User.create(name: "Employee(Billy)", address: "123 Test St", city: "Denver", state: "CO", zip: "80204", email: "merchant1@example.com", password: "password_merchant", role: 2)
merchant_2 = User.create(name: "Employee(Johnny)", address: "123 Test St", city: "Denver", state: "CO", zip: "80204", email: "merchant2@example.com", password: "password_merchant", role: 2)
merchant_3 = User.create(name: "Employee(Karen)", address: "123 Test St", city: "Hollywood", state: "CA", zip: "80204", email: "merchant3@example.com", password: "password_merchant", role: 2)
merchant_4 = User.create(name: "Employee(Jenn)", address: "123 Test St", city: "Tampa Bay", state: "FL", zip: "80204", email: "merchant4@example.com", password: "password_merchant", role: 2)

#discounts
merchant.discounts.create(quantity: 10, percentage: 5, applied: false)
merchant.discounts.create(quantity: 20, percentage: 10, applied: false)
merchant.discounts.create(quantity: 3, percentage: 2, applied: false)

#employees
bike_shop.add_employee(merchant)
bike_shop.add_employee(merchant_1)
dog_shop.add_employee(merchant_2)
misc_shop.add_employee(merchant_3)
tires_shop.add_employee(merchant_4)

#orders
order1 = user.orders.create(id: 3, name: "Colin", address: "400 Wash", city: "Denver", state: "CO", zip: 80203)

order1.item_orders.create(order_id: order1.id, item: pull_toy, quantity: 1, price: pull_toy.price)
order1.item_orders.create(order_id: order1.id, item: dog_bone, quantity: 2, price: dog_bone.price)
order1.item_orders.create(order_id: order1.id, item: tire, quantity: 3, price: tire.price)
order1.item_orders.create(order_id: order1.id, item: rim, quantity: 4, price: rim.price)
order1.item_orders.create(order_id: order1.id, item: chew_rope, quantity: 5, price: chew_rope.price)
order1.item_orders.create(order_id: order1.id, item: chips, quantity: 10, price: chips.price)

order2 = user.orders.create(id: 4, name: "David", address: "2931 Carrier St", city: "Las Vegas", state: "NV", zip: 80203, status: "Shipped")

order2.item_orders.create(order_id: order2.id, item: pull_toy, quantity: 1, price: pull_toy.price)
order2.item_orders.create(order_id: order2.id, item: dog_bone, quantity: 2, price: dog_bone.price)
order2.item_orders.create(order_id: order2.id, item: rim, quantity: 4, price: rim.price)
order2.item_orders.create(order_id: order2.id, item: axle, quantity: 5, price: axle.price)

order3 = merchant_1.orders.create(id: 5, name: "Max", address: "123 Martin", city: "Colorado Springs", state: "CO", zip: 80203, status: "Packaged")

order3.item_orders.create(order_id: order3.id, item: pull_toy, quantity: 1, price: pull_toy.price)
order3.item_orders.create(order_id: order3.id, item: kong_toy, quantity: 2, price: dog_bone.price)
order3.item_orders.create(order_id: order3.id, item: tire, quantity: 3, price: tire.price)
order3.item_orders.create(order_id: order3.id, item: chew_rope, quantity: 9, price: axle.price)
order3.item_orders.create(order_id: order3.id, item: seat, quantity: 10, price: seat.price)

order4 = merchant_4.orders.create(id: 6, name: "Jenn", address: "333 Charles", city: "Tampa Bay", state: "FL", zip: 80203, status: "Cancelled")

order4.item_orders.create(order_id: order4.id, item: squeaky_toy, quantity: 4, price: pull_toy.price)
order4.item_orders.create(order_id: order4.id, item: kong_toy, quantity: 2, price: dog_bone.price)
