class Admin::MenuCategoriesController < Admin::AdminController
  def show
  end

  def index
  end

  def new
    @menu_category = MenuCategory.new

    respond_to do |format|
      format.js
    end
  end

  def create
    @menu_category = MenuCategory.new(menu_category_params)

    respond_to do |format|
      if @menu_category.save
        format.html {redirect_to admin_franks_cafe_url, notice: 'Category created successfully.'}
        format.js
      end
    end
  end

  def edit
    @menu_category = MenuCategory.find(params[:id])

    respond_to :js
  end

  def update
    @menu_category = MenuCategory.find(params[:id])

    respond_to do |format|
      if @menu_category.update(menu_category_params)
        format.html {redirect_to admin_franks_cafe_url, notice: 'Category udpated successfully.'}
      end
    end
  end

  def destroy
    @menu_category = MenuCategory.find(params[:id])
    @menu_category.destroy

    respond_to :js
  end

  private

  def menu_category_params
    params.require(:menu_category).permit(:name)
  end
end
