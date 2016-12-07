class Admin::OrdersController < Admin::AdminController


  def index
    @orders = Order.order('created_at asc')
  end

  def show
  	@order = Order.find(params[:id])
  end
end
