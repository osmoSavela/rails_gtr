class Admin::EventsController < ApplicationController

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    if @event.save
      respond_to do |format|
        format.html{redirect_to admin_events_url, notice: 'Event succesffully created.'}
      end
    end
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    if @event.update(event_params)
      respond_to do |format|
        format.html{redirect_to admin_events_url, notice: 'Event succesffully updated.'}
      end
    end
  end

  def index
    @events = Event.order('event_start_date asc')
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.js
    end
  end

  private

  def event_params
    params.require(:event).permit(:title, :description, :event_start_date, :event_end_date, :event_start_time, :event_end_time)
  end
end
