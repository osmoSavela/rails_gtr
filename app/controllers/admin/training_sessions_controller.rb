class Admin::TrainingSessionsController < Admin::AdminController

  def new
    @training_session = TrainingSession.new
  end

  def edit
    @training_session = TrainingSession.find(params[:id])

  end

  def update
    @training_session = TrainingSession.find(params[:id])

    respond_to do |format|
      if @training_session.update(training_session_params)
        format.html{redirect_to admin_training_sessions_url, notice: 'Training Session Successfully Updated.'}
      end
    end
  end

  def create
    @training_session = TrainingSession.new(training_session_params)

    respond_to do |format|
      if @training_session.save
        format.html {redirect_to admin_training_sessions_url}
      end
    end
  end

  def destroy
    @training_session = TrainingSession.find(params[:id])
    @training_session.destroy

    respond_to do |format|
      format.html {redirect_to admin_training_sessions_url, notice: "Training Session Successfuly Deleted."}
    end
  end

  def calendar
    @sessions = TrainingSession.order(:session_date)


  end

  def index
    @training_sessions = TrainingSession.order(:session_date)

    @training_sessions = @training_sessions.group_by{|s| s.session_date}
  end

  def show
    @training_session = TrainingSession.find(params[:id])
  end

  private

  def training_session_params
      params.require(:training_session).permit(:session_date, :quantity_available, :instructor_id, :start_time, :end_time, :training_class_id, :deluxe_package)
  end
end
