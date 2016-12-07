class UsersController < ApplicationController

  before_action :set_user, except: [:new, :create, :verify_existing_user, :import]
  before_action :require_login, except: [:new, :create, :update, :verify_existing_user, :link_account]
  before_action :authorize_user, except: [:new, :create, :confirm_user, :import, :verify_existing_user, :update, :link_account]

  def authorize_user
      logger.debug "authorize_user"
      redirect_to root_url, notice: 'You are not authorized to view that page.' if current_user.id != @user.id && !current_user.admin?
  end

  def billing
    @user = User.find(params[:user_id])
    @payments = @user.payments.order('created_at asc')
  end

  def member_reservation
    @user = User.find(params[:user_id])
    @timeslots = params[:timeslots].split(" ")
    @date = params[:date]
    @number_of_guests = params[:number_of_guests]
    @gun_range = GunRange.find(params[:gun_range_id])
    @gun_type = (params[:gun_type])
    @hours_used = (params[:hours_used])
    @lane = Lane.find(params[:lane_id])            
    respond_to do |format|
      if @user.create_member_reservation(@timeslots, @gun_type, @gun_range, @number_of_guests,@lane, @date, @hours_used)        
        format.html {redirect_to root_url, notice: 'You have succesfully created a reservation. You will receive a confirmation email shortly.'}
      end
    end
  end

  def reservations
    @user = User.find(params[:user_id])
    @reservations = @user.reservations.order('day desc')
  end

  def waiver
    @user = User.find(params[:user_id])
    if @user.waiver
      @waiver = @user.waiver
    else
      @waiver = Waiver.new
    end

    @ref_url = params[:ref_url] if params[:ref_url]

  end


  def verify_existing_user
    @user = User.verify_account(params[:last_name], params[:email])
    if @user.present?
      @first_name = @user.first_name
      @last_name = @user.last_name
      @email = @user.email
      @phone = @user.phone
      @address1 = @user.address1
      @address2 = @user.address2
      @city = @user.city
      @state = @user.state
      @zip = @user.zip
      @foid_id = @user.foid_id
    else
      redirect_to :back, notice: "We could not verify your information at this time. If the problem persists, please contact GTR at (847) 782-8888"
    end
  end

  def link_account

  end

  def import
    if params[:file].present?
      errors = User.import(params[:file])
      if errors > 0
        redirect_to admin_users_url, notice: "Users have been successfully imported. #{errors} users could not be saved."
      else
        redirect_to admin_users_url, notice: 'Users have been successfully imported.'
      end
    else
      redirect_to admin_users_url, notice: "You must include a file."
    end
  end

  def edit

  end


  def destroy
  end

  def update


    respond_to do |format|
      if @user.update(user_params)
        if params[:verifying_user].present?
          sign_in(@user)
          format.html { redirect_to root_url, notice: "Welcome #{@user.first_name}, you have successfully linked your account and signed in." }
        else
          format.html { redirect_to root_url, notice: 'You successfully updated your account.' }
        end
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

    private

    def set_user
      logger.debug "set_user"
      @user = User.find_by_id(params[:id]) || User.find_by_id(params[:user_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:first_name, :last_name, :address1, :address2, :email, :phone, :cell_phone, :work_phone, :city, :state, :zip, :dob, :admin, :foid_id, :password, :password_confirmation, :hours_available, :stripe_customer_token, :guests_left, :membership_id, :membership_type, :foid_or_license)
    end
end
