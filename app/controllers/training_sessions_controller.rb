class TrainingSessionsController < ApplicationController
  before_filter :authenticate_user!, only: [:show]

  def index

  	@training_sessions = TrainingSession.current
  	@training_sessions = @training_sessions.sort_by{|ts| ts.session_date}
    @training_sessions = @training_sessions.group_by{|s| s.session_date}

  end

  def show
  	@training_session = TrainingSession.find(params[:id])
    @payment = Payment.new
  	respond_to do |format|
  		format.html
  		format.js
  	end
  end

  def show_details
    @training_session = TrainingSession.find(params[:id])
    
  end


  def calendar
     @sessions = TrainingSession.current
  end

end
