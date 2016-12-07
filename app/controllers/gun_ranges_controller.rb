class GunRangesController < ApplicationController
  before_filter :check_date, only: [:show]
  # before_action :redirect_to_under_construction

  def check_date
    if !params[:date].present? || params[:date].to_date < Date.today
        redirect_to gun_range_calendar_url(params[:id]), notice: 'Please choose a date that is in the future.'
    end
  end


  def show
    @gun_range = GunRange.find(params[:id])
    @lanes = @gun_range.lanes
    @date = params[:date].to_date if params[:date]
  end

  def index
    @gun_ranges = GunRange.all
  end

  def calendar
    @gun_range = GunRange.find(params[:gun_range_id])
  end

end
