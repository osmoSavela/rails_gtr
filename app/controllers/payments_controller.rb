class PaymentsController < ApplicationController
  before_action :set_payment, only: [:show, :destroy]


  # POST /payments
  # POST /payments.json
  def create
    @payment = Payment.new(payment_params)
    @timeslots = params[:timeslots].split(" ") if params[:timeslots]
    @date = params[:date] if params[:date]
    @gun_range = GunRange.find(params[:gun_range_id]) if params[:gun_range_id]
    @lane = Lane.find(params[:lane_id]) if params[:lane_id]
    @training_session = TrainingSession.find(params[:training_session_id]) if params[:training_session_id]
    #add deluxe package price if selected
    @payment.amount += (@training_session.training_class.deluxe_package.price * 100) if params[:deluxe_package].present?
    @membership = Membership.find(params[:membership_id]) if params[:membership_id]
    @frequency = params[:frequency]
    @user = @payment.user
    


    respond_to do |format|
      if @training_session.present?
        if @payment.save_training_payment(@training_session)
          @payment.set_paymentable(@training_session)
          UserTrainingSession.create(user_id: @payment.user_id, payment_method: 'Credit Card', training_session_id: @training_session.id, paid: true, deluxe_package: params[:deluxe_package])          
          format.html { redirect_to root_url, notice: "Registration Successful!"}
          format.json { render action: 'show', status: :created, location: @payment }
        else
          format.html {redirect_to :back, alert: "Something went wrong! Please try again."}
        end
      elsif @timeslots.present?
      ########## Lane Reservation PAYMENT #####################
        if @payment.save_reservation_payment(@timeslots, @date, @gun_range, @lane, params[:gun_type], params[:number_of_guests])
          format.html {redirect_to root_url, notice: "Success! Your reservation has been made Check your email for confirmation."}
        else
          format.html {redirect_to :back, alert: "Something went wrong! Please try again."}
        end

      elsif @membership.present?
      ########## MEMBERSHIP PAYMENT #####################
        if @frequency == 'annual'
          if @payment.save_annual_membership_payment(@membership)
            @user.set_annual_membership(@membership)
            @user.create_subscription(@membership, @payment)
            UserMailer.admin_membership_confirmation(@payment.user).deliver
            format.html{ redirect_to root_url, notice: "Welcome to the GTR Sporting Club, enjoy your new membership!"}
          else
            format.html {redirect_to :back, alert: "Something went wrong! Please try again."}
          end
        elsif @frequency == 'monthly'
          if @payment.save_first_monthly_membership_payment(@membership)
            @user.set_monthly_membership(@membership)
            @user.create_subscription(@membership, @payment)
            UserMailer.admin_membership_confirmation(@payment.user).deliver
            format.html{ redirect_to root_url, notice: "Welcome to the GTR Sporting Club, enjoy your new membership!"}
          else
            format.html {redirect_to :back, alert: "Something went wrong! Please try again."}
          end

        end


      ##################################################
      else
      ########## CAFE PAYMENT ###########################
        if @payment.save_cafe_payment
          if params[:delivery].present?
            order = Order.create(user_id: @payment.user_id, delivery: true, payment_method: 'card', total_price: @payment.amount/100, item_total: @user.outstanding_order_total)
            OrderDeliveryAddress.create(order_id: order.id, address: params[:address], city: params[:city], state: params[:state], zip: params[:zip])
          else
            order = Order.create(user_id: @payment.user_id, payment_method: 'card', total_price: @payment.amount/100, item_total: @user.outstanding_order_total)
          end
          @payment.set_paymentable(order)

          format.html { redirect_to order_url(order), notice: "Order created!"}
          format.json { render action: 'show', status: :created, location: @payment }
        else
          format.html {redirect_to :back, alert: "Something went wrong! Please try again."}
        end
      #############################################################
      end
    end
  end



  # DELETE /payments/1
  # DELETE /payments/1.json
  def destroy
    @payment.destroy
    respond_to do |format|
      format.html { redirect_to payments_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payment
      @payment = Payment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def payment_params
      params.require(:payment).permit(:user_id, :amount, :stripe_card_token, :card_last_4, :card_brand, :description, :charge_token, :paymentable_type, :paymentable_id, :training_session_id)
    end
end
