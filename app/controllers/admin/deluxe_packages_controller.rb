class Admin::DeluxePackagesController < ApplicationController
  def create
    @deluxe_package = DeluxePackage.new(deluxe_package_params)
    if @deluxe_package.save
      respond_to do |format|
        format.html {redirect_to admin_deluxe_packages_url, notice: "You have succesffully created a deluxe package for #{@deluxe_package.training_class.name}"}
      end
    end
  end

  def new
    @deluxe_package = DeluxePackage.new
  end

  def edit
    @deluxe_package = DeluxePackage.find(params[:id])

  end

  def update
    @deluxe_package = DeluxePackage.find(params[:id])

    respond_to do |format|
      if @deluxe_package.update(deluxe_package_params)
        format.html {redirect_to admin_deluxe_packages_url, notice: "Deluxe package successfully updated."}
      else
        format.html {redirect_to :back, notice: "Oops, that didn't work. Please try again."}
      end
    end
  end

  def destroy
    @deluxe_package = DeluxePackage.find(params[:id])
    @deluxe_package.destroy

    respond_to :js
  end

  def index
    @deluxe_packages = DeluxePackage.all
  end


  private

  def deluxe_package_params
    params.require(:deluxe_package).permit(:description, :value, :price, :training_class_id)
  end

end
