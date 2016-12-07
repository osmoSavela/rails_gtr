class OrderItemOption < ActiveRecord::Base
	belongs_to :order_item
	belongs_to :menu_item_option
end
