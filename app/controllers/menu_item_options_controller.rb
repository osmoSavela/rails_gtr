class MenuItemOptionsController < ApplicationController

	def create
		@menu_item_option = MenuItemOption.new
		@menu_item_option.name = params[:menu_item_option][:name]
		@menu_item_option.menu_item_id = params[:menu_item_option][:menu_item_id]

		respond_to do |format|
			if @menu_item_option.save
				format.js
			end
		end
	end

	def new
		@menu_item = MenuItem.find(params[:menu_item_id])

		respond_to :js
	end

	def destroy
		@menu_item_option = MenuItemOption.find(params[:id])
		@menu_item_option.destroy

		respond_to :js
	end
end
