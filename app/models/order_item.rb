class OrderItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :order
  belongs_to :menu_item
  has_many :order_item_options

  def total_price
    self.quantity * self.price
  end

end
