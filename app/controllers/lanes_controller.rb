class LanesController < ApplicationController
  before_filter :authenticate_user!, only: [:show]
  before_filter :check_for_waiver, only: [:show]

  def check_for_waiver
    unless current_user.admin
      if !current_user.waiver.present?
        redirect_to user_waiver_url(current_user, ref_url: request.original_url), notice: 'You must fill out a waiver in order to use the gun range. Please fill out the form below.'
      end
    end
  end

  def index
    @gun_range = GunRange.find(params[:gun_range_id])
    @lanes = @gun_range.lanes
  end

  def show
    @gun_range = GunRange.find(params[:gun_range_id])
    @lane = Lane.find(params[:id])
    @date = params[:date].to_date if params[:date]
    @reservations = @lane.reservations


  end

end
