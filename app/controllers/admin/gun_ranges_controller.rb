class Admin::GunRangesController < Admin::AdminController
  # before_filter :check_date, only: [:show]

  def check_date
    if !params[:date].present? || params[:date].to_date < Date.today
        redirect_to gun_range_calendar_url(params[:id]), notice: 'Please choose a date that is in the future.'
    end
  end

  def new
    @gun_range = GunRange.new
  end

  def edit
    @gun_range = GunRange.find(params[:id])
  end

  def select_range
    @gun_ranges = GunRange.all
  end

  def calendar
    @gun_range = GunRange.find(params[:gun_range_id])
  end

  def index
    @gun_ranges = GunRange.all
  end

  def create
    @gun_range = GunRange.new(gun_range_params)
    respond_to do |format|
      if @gun_range.save
        format.html {redirect_to admin_gun_ranges_url, alert: "Range created successfully."}
      else
        format.html {redirect_to :back, alert: "Something went wrong! Please try again."}
      end
    end
  end

  def update
    @gun_range = GunRange.find(params[:id])
    respond_to do |format|
      if @gun_range.update(gun_range_params)
        format.html {redirect_to admin_gun_ranges_url, notice: 'Gun Range successfully updated.'}
      end
    end
  end


  def show
    @gun_range = GunRange.find(params[:id])
    @lanes = @gun_range.lanes.order('number asc')

    @date = params[:date].to_date if params[:date]
  end


  def destroy
    @gun_range = GunRange.find(params[:id])
    @gun_range.destroy

    respond_to :js

  end

    private

    # Never trust parameters from the scary internet, only allow the white list through.
    def gun_range_params
      params.require(:gun_range).permit(:name)
    end
end
