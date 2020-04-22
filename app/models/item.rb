class Item <ApplicationRecord
  belongs_to :merchant
  has_many :reviews, dependent: :destroy
  has_many :item_orders
  has_many :orders, through: :item_orders

  validates_presence_of :name,
                        :description,
                        :price,
                        :inventory
  validates_numericality_of :price, greater_than: 0
  validates_numericality_of :inventory, greater_than: 0, on: :item_inventory


  def average_review
    reviews.average(:rating)
  end

  def sorted_reviews(limit, order)
    reviews.order(rating: order).limit(limit)
  end

  def no_orders?
    item_orders.empty?
  end

  def self.most_popular
    select('items.*, SUM(quantity) as total_quantity').joins(:item_orders).group('items.id').order('total_quantity DESC').limit(5)
  end

  def self.least_popular
    select('items.*, SUM(quantity) as total_quantity').joins(:item_orders).group('items.id').order('total_quantity').limit(5)
  end

  def can_be_fulfilled(amount_wanted)
    amount_wanted < inventory
  end

  def default_photo?
    self.image = "https://dapp.dblog.org/img/default.jpg" if self.image == ""
    self.errors.add(:inventory, "Inventory must be greater than 0,") if self.inventory < 1
  end

  def apply_discount(discount)
    if discount.nil?
      false
    else
      self.discounted_price = self.price - (discount.percentage.to_f / 100 * self.price)
      self.save
    end
  end
end
