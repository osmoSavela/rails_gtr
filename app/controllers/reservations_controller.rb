class ReservationsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :check_for_waiver


  def check_for_waiver
    unless current_user.admin
      if !current_user.waiver.present?
        redirect_to user_waiver_url(current_user), notice: 'You must fill out a waiver in order to use the gun range. Please fill out the form below.'
      end
    end
  end

  def create
    @reservation = Reservation.new(reservation_params)

    respond_to do |format|
      if @reservation.save
        format.html {redirect_to gun_range_lane_url(@reservation.gun_range, @reservation.lane, date: @reservation.day), notice: "Lane reserved successfully."}
      else
        format.html {redirect_to :back, notice: "Sorry, that didn't work. Please try again."}
      end
    end
  end

  def confirm_reservation
    @user = current_user
    @payment = Payment.new
    @number_of_guests = params[:number_of_guests]
    @gun_range = GunRange.find(params[:gun_range_id])
    @lane = Lane.find(params[:lane_id])
    @date = params[:date].to_date if params[:date]
    @gun_type = params[:gun_type]

    if @gun_type == "Handgun"
      if @user.membership.present?
        @per_hour = 20
      else
        @per_hour = 22
      end
    else
      if @user.membership.present?
        @per_hour = 22
      else
        @per_hour = 24
      end
    end

    @times = []

    params.each do |param|
      if param[0].start_with?("timeslot-")
        @times << param[0].gsub("timeslot-", "").to_datetime
      end
    end

    if !@times.present?
      redirect_to gun_range_lane_url(@gun_range, @lane, date: @date), notice: "You must select a time to continue!"
    end

  end

  def index
    @reservations = current_user.reservations
  end


  def destroy
    @reservation = Reservation.find(params[:id])
    @reservation.destroy

  end

    private

    # Never trust parameters from the scary internet, only allow the white list through.
    def reservation_params
      params.require(:reservation).permit(:user_id, :gun_range_id, :lane_id, :reservation_time, :day, :master_reservation_id)
    end
end
