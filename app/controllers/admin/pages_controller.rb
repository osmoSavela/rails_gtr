class Admin::PagesController < Admin::AdminController

  def member_list
    if params[:search]
      @members = User.members.where('lower(first_name) like ? or lower(last_name) like ?', "%#{params[:search].downcase}%", "%#{params[:search].downcase}%")
      @members = @members.paginate(page: params[:page], per_page: 50)
    else
      @members = User.members.paginate(page: params[:page], per_page: 50)
    end
  end

  def homepage_video
    @homepage_video = HomepageVideo.first 
  end

  def dashboard

  end

  def franks_cafe
  	@menu_categories = MenuCategory.all
  	@recent_orders = Order.last(10)
  end

  def create_reservation
    @master_reservation = MasterReservation.new
    @gun_range = GunRange.find(params[:gun_range_id])
    @lane = Lane.find(params[:lane_id])
    @date = params[:date].to_date if params[:date]
    @gun_type = params[:gun_type]


    if @gun_type == "Handgun"
      @per_hour = 20
    else
      @per_hour = 22
    end

    if params[:new_user]
      @times = params[:timeslots]
      @times = @times.map{|t| t.to_datetime}
    else
      @times = []

    params.each do |param|
      if param[0].start_with?("timeslot-")
        @times << param[0].gsub("timeslot-", "").to_datetime
      end
    end
  end
  end


end
