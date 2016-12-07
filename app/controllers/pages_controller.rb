class PagesController < ApplicationController
  before_filter :authenticate_user!, only: [:apply]
  respond_to :json, only: [:stripe_webhooks]
  protect_from_forgery :except => :stripe_webhooks

  # before_action :redirect_to_under_construction


  def show_membership_details
    @membership = Membership.find(params[:membership_id])
    respond_to :js
  end

  def checkin
    @reservations = Reservation.today.order('reservation_time asc')


  end

  def todays_reservations
  end

  

  def master_checkin
    @reservation = Reservation.find(params[:reservation_id])


    respond_to do |format|
      if params[:last_name]
        if MasterReservation.confirm_checkin(params[:last_name], params[:reservation_id])
          format.html {redirect_to :back, notice: "You have checked in successfully."}
        else
          format.html {redirect_to :back, notice: "The last name you entered did not match the last name of the reservation. Please try again."}
        end
      end
      format.js
    end
  end

  def stripe_webhooks
    Rails.logger.info("STRIPE_WEBHOOK_PARAMS: #{params.inspect}")

    event_json = JSON.parse(request.body.read)
    event_type = event_json['type']
    customer_id = event_json['data']['object']['customer']
    amount = event_json['data']['object']['total']
    charge = event_json['data']['object']['charge']

    user = User.find_by_stripe_customer_token(customer_id)

    if user.present?
      if event_type == "invoice.payment_succeeded"
        user.create_stripe_webhook_payment(amount,charge)
      else
        UserMailer.failed_payment(user).deliver
      end
    end

    render nothing: true, :status => 200
  end

  def events
    @events = Event.future.order('event_start_date asc')
  end

  def apply
    @membership = Membership.find_by_name(params[:membership])
    @payment = Payment.new
    @frequency = params[:frequency]
    if @frequency == 'monthly'
      if current_user.stripe_customer_token && current_user.membership && current_user.membership_expires_on > Date.today
        redirect_to root_url, notice: "You already have a monthly #{current_user.membership.name} plan!"
      end
      @amount = @membership.monthly_price
    elsif @frequency == 'annual'
      @amount = @membership.annual_price
    end
  end

  def welcome
    @url = HomepageVideo.first.url if HomepageVideo.first.present?
  end

  def about
    @memberships = Membership.all
  end

  def firearm_training
    @training_classes = TrainingClass.active
  end

  def franks_cafe
    @user = current_user
  	@menu_categories = MenuCategory.all
    @new_items = @user.order_items.where(order_id: nil) if @user

  end

  def confirm_order
    @payment = Payment.new
    @user = current_user
    @new_items = @user.order_items.where(order_id: nil)
    @item_total = @new_items.map{|i| i.total_price}.inject(:+)
    @payment_method = params[:payment_method]
  end


end
