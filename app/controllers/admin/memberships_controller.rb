class Admin::MembershipsController < ApplicationController
  def new
    @membership = Membership.new
  end

  def create
    @membership = Membership.new(membership_params)

    if @membership.save
      respond_to do |format|
        format.html{redirect_to admin_memberships_url, notice: 'Membership Successfully Created!'}
      end
    end
  end

  def edit
    @membership = Membership.find(params[:id])
  end

  def show
  end

  def index
    @memberships = Membership.all
  end

  def update
    @membership = Membership.find(params[:id])
    if @membership.update(membership_params)
      respond_to do |format|
        format.html{redirect_to admin_memberships_url, notice: 'Membership Successfully Updated!'}
      end
    end
  end

  def destroy

  end

  private

  def membership_params
    params.require(:membership).permit(:name, :description, :monthly_price, :annual_price, :range_hours, :training_discount, :range_ammo_discount, :accessory_discount, :private_instructor_discount, :annual_guest_passes, :lounge_access, :hex_color)
  end
end
