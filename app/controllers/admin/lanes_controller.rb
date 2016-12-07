class Admin::LanesController < Admin::AdminController

  def new
    @gun_range = GunRange.find(params[:gun_range_id])
    @lane = Lane.new
  end

  def create
    @lane = Lane.new(lane_params)
    respond_to do |format|
      if @lane.save
        format.html {redirect_to admin_gun_range_url(@lane.gun_range), notice: "Lane created successfully."}
      else
        format.html {redirect_to :back, notice: "Something went wrong! Please try again."}
      end
    end
  end

  def edit
    @gun_range = GunRange.find(params[:gun_range_id])
    @lane = Lane.find(params[:id])

  end

  def update
    @lane = Lane.find(params[:id])

    respond_to do |format|
      if @lane.update(lane_params)
        format.html{redirect_to admin_gun_range_url(@lane.gun_range), notice: 'Lane Successfully Updated.'}
      end
    end

  end


  def show
    @gun_range = GunRange.find(params[:gun_range_id])
    @lane = Lane.find(params[:id])
    @date = params[:date].to_date if params[:date]
    @reservations = @lane.reservations
  end

  def destroy
    @lane = Lane.find(params[:id])
    @lane.destroy

  end

    private

    # Never trust parameters from the scary internet, only allow the white list through.
    def lane_params
      params.require(:lane).permit(:gun_range_id, :number)
    end

end
