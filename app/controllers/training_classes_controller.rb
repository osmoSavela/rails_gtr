class TrainingClassesController < ApplicationController
  def show
  end

  def index
    @training_sessions = TrainingSession.order(:session_date)
    @training_sessions = @training_sessions.group_by{|s| s.session_date}
  end
end
