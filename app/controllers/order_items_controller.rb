class OrderItemsController < ApplicationController

  def new
    @menu_item = MenuItem.find(params[:menu_item_id])
    @order_item = OrderItem.new
    @user = current_user

    respond_to do |format|
      format.js
    end
  end

  def create
    @menu_item = MenuItem.find(params[:order_item][:menu_item_id])
    @order_item = OrderItem.new(order_item_params)    
    @user = current_user
    respond_to do |format|
      if @order_item.save
        @menu_item.menu_item_options.each do |option|
          if params[option.name].present?
            OrderItemOption.create!(menu_item_option_id: option.id, order_item_id: @order_item.id)
          end
        end
        format.js
      else
        format.html {redirect_to :back, alert: "Something went wrong! Please try again."}
      end
    end

  end


  def destroy
    @order_item = OrderItem.find(params[:id])
    @order_item.destroy
    respond_to do |format|
      format.js
    end
  end

    private

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_item_params
      params.require(:order_item).permit(:user_id, :order_id, :menu_item_id, :price, :quantity)
    end
end
