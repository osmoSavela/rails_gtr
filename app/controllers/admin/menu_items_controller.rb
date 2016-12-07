class Admin::MenuItemsController < Admin::AdminController
  def show
  end

  def index
  end

  def new
    @category = MenuCategory.find(params[:category_id])
    @menu_item = MenuItem.new()

    respond_to do |format|
      format.js
    end
  end

  def create
    @menu_item = MenuItem.new(menu_item_params)
    respond_to do |format|
      if @menu_item.save
        format.js
        format.html {redirect_to menu_categories_url, notice: 'Item created successfully.'}
      end
    end
  end

  def edit
    @menu_item = MenuItem.find(params[:id])
    @category = @menu_item.menu_category
    respond_to :js
  end

  def update
    @menu_item = MenuItem.find(params[:id])

    respond_to do |format|
      if @menu_item.update(menu_item_params)
        format.js
      end
    end
  end

  def destroy
    @menu_item = MenuItem.find(params[:id])
    @menu_item.destroy

    respond_to do |format|
      format.js
    end
  end

  private

  def menu_item_params
    params.require(:menu_item).permit(:name, :price, :menu_category_id, :description)
  end
end
