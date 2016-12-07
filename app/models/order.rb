class Order < ActiveRecord::Base
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :payments, as: :paymentable
  has_one :order_delivery_address

  after_create :assign_order_to_items
  before_create :set_total_price


  def assign_order_to_items
    self.user.order_items.where(order_id: nil).map{ |item| item.update order_id: self.id }
  end

  def set_total_price
    if self.delivery
      total = self.delivery_total + self.item_total
    else
      total = self.item_total
    end

    self.total_price = total
  end

end
