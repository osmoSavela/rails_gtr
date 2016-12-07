class OrdersController < ApplicationController

  def create
    @order = Order.new(order_params)
    respond_to do |format|
      if @order.save
        OrderDeliveryAddress.create(order_id: @order.id, address: params[:address], city: params[:city], state: params[:state], zip: params[:zip]) if @order.delivery
        format.html {redirect_to order_url(@order), alert: "Order has been placed!"}
      else
        format.html {redirect_to :back, alert: "Something went wrong! Please try again."}
      end
    end
  end


  def show
    @order = Order.find(params[:id])
    @order_items = @order.order_items
  end


  def destroy
  end

    private

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:user_id, :delivery, :item_total, :delivery_total, :total_price, :special_instructions, :completed, :payment_method)
    end
end
