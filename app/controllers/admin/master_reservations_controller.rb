class Admin::MasterReservationsController < ApplicationController
  
  before_filter :make_sure_user_doesnt_exist, on: [:create]
  
  def make_sure_user_doesnt_exist
    if User.find_by_email(params[:email])
      redirect_to :back, notice: 'A user with this email already exists in the system. Please use another email.'
    end
  end

  def create
    @master_reservation = MasterReservation.new(master_reservation_params)

    @gun_range = GunRange.find(params[:gun_range_id])
    @lane = Lane.find(params[:lane_id])
    @date = params[:date].to_date
    @timeslots = params[:timeslots].split(" ") if params[:timeslots]

    if params[:new_user].present?
  			user = User.admin_create_user(params[:first_name], params[:last_name], params[:email])
  			@master_reservation.user_id = user.id
		else
			email = params[:master_reservation][:user_email].split.last
			@master_reservation.user_id = User.find_by_email(email).id
		end
    
    
    respond_to do |format|
      if @master_reservation.save
        @master_reservation.create_reservations(@timeslots, @gun_range, @lane, @date)
        UserMailer.reservation_email(@master_reservation).deliver
        format.html {redirect_to admin_dashboard_url, notice: "Reservation successfully created."}
      else
        format.html {redirect_to :back, notice: "Oops, that didn't work. Please try again."}
      end
    end

  end

  def index
    if params[:date].present?
      reservations = Reservation.for_date(params[:date])
      @day = params[:date].to_date.strftime("%m/%d/%y")

    else
      reservations = Reservation.today.order('reservation_time asc')
      @day = Time.zone.now.strftime("%m/%d/%y")
    end

      @master_reservations = reservations.map{|r| r.master_reservation}.uniq
  end


  private

   # Never trust parameters from the scary internet, only allow the white list through.
   def master_reservation_params
     params.require(:master_reservation).permit(:paid, :payment_method, :user_id, :gun_type)
   end


end
