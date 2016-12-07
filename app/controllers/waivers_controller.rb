class WaiversController < ApplicationController

  before_filter :authenticate_user!

  def new
    @user = User.find(params[:user_id])
    @ref_url = params[:ref_url]
  end

  def show
    @user = User.find(params[:user_id])
    @waiver = Waiver.find(params[:id])
  end

  def create
    @waiver = Waiver.new(waiver_params)
    respond_to do |format|
      if @waiver.save
        if params[:ref_url]
          format.html{redirect_to params[:ref_url]}
        else
          format.html{redirect_to user_url(@waiver.user)}
        end
      else
          format.html{redirect_to :back, notice: @waiver.errors.full_messages.first}
      end
    end
  end
  
  def update
    @waiver = Waiver.find(params[:id])
    
    respond_to do |format|
      if @waiver.update(waiver_params)
        if current_user.admin
          format.html {redirect_to admin_users_url}
        else
          format.html {redirect_to user_url(@waiver.user)}
        end
      else
        format.html
      end
    end
  end

  def index

  end

  def destroy

  end

  private

  def waiver_params
    params.require(:waiver).permit(:first_name, :foid_or_license, :middle_name, :last_name, :address1, :address2, :city, :state, :zip, :user_id, :date_of_birth, :mental_illness, :criminal_record, :substance_abuse, :us_citizen, :email)
  end
end
