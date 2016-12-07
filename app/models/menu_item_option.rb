class MenuItemOption < ActiveRecord::Base
	belongs_to :menu_item
	has_many :order_item_options
end
