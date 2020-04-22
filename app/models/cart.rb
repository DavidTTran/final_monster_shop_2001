class Cart
  attr_reader :contents

  def initialize(contents)
    @contents = contents
  end

  def add_item(item)
    @contents[item] = 0 if !@contents[item]
    @contents[item] += 1
  end

  def total_items
    @contents.values.sum
  end

  def items
    item_quantity = {}
    @contents.each do |item_id,quantity|
      item_quantity[Item.find(item_id)] = quantity
    end
    item_quantity
  end

  def add_quantity(item)
    @contents[item] += 1
  end

  def subtract_quantity(item)
    @contents[item] -= 1
  end

  def quantity_zero?(item)
    @contents[item].zero?
  end

  def limit_reached?(item)
    @contents[item] == Item.find(item).inventory
  end

  def subtotal(item)
    if apply_discount(item)
      item.discounted_price * @contents[item.id.to_s]
    else
      item.price * @contents[item.id.to_s]
    end
  end

  def total
    items.sum do |item, quantity|
      if apply_discount(item)
        item.discounted_price * quantity
      else
        item.price * quantity
      end
    end
  end

  def discount_applied?
    items.any? do |item, quantity|
      item.merchant.discounts.any? do |discount|
        quantity >= discount.quantity
      end
    end
  end

  def apply_discount(item)
    discount = item.merchant.discounts.find_all do |discount|
      discount.quantity <= items[item]
    end.max_by { |discount| discount.percentage }

    item.apply_discount(discount)
  end
end
