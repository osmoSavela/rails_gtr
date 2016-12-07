class MenuItem < ActiveRecord::Base
	belongs_to :menu_category
  	has_many :order_items, dependent: :destroy
  	has_many :orders, through: :order_items
  	has_many :menu_item_options, dependent: :destroy
end
