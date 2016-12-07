class MasterReservationsController < ApplicationController
  before_filter :authenticate_user!, only: [:show]

  def create
      @master_reservation = MasterReservation.new(master_reservation_params)

      @gun_range = GunRange.find(params[:gun_range_id])
      @lane = Lane.find(params[:lane_id])
      @date = params[:date].to_date


      respond_to do |format|
        if @master_reservation.save
          @master_reservation.create_reservations(params[:timeslots], @gun_range, @lane, @date)
          UserMailer.reservation_email(@master_reservation).deliver
          format.html {redirect_to root_url, notice: "Reservation successfully created."}
        else
          format.html {redirect_to :back, notice: "Oops, that didn't work. Please try again."}
        end
      end
  end

  def index

  end

  def member_reservation
    
  end


   private

    # Never trust parameters from the scary internet, only allow the white list through.
    def master_reservation_params
      params.require(:master_reservation).permit(:paid, :payment_method, :user_id)
    end

end
