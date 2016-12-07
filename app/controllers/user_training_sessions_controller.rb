class UserTrainingSessionsController < ApplicationController

  before_action :set_user, only: [:index]
  before_action :require_login
  before_action :authorize_user, only: [:index]

  def authorize_user
    logger.debug "authorize_user"
    redirect_to root_url, notice: 'You are not authorized to view that page.' if current_user.id != @user.id && !current_user.admin?
  end

  def index
    @user = User.find(params[:user_id])
    @user_training_sessions = @user.user_training_sessions
  end

  def new
  end

  def create
    @user_training_session = UserTrainingSession.new(user_training_session_params)

    respond_to do |format|
      if @user_training_session.save
        format.html {redirect_to root_url, notice: 'Thanks for Registering for the class. You will receive an email shortly.'}
      else
        format.html {redirect_to :back, notice: "Oops, that didn't work! Please try again."}
      end
    end
  end


  def destroy
  end

  private

  def set_user
    logger.debug "set_user"
    @user = User.find_by_id(params[:id]) || User.find_by_id(params[:user_id])
  end

  def user_training_session_params
    params.require(:user_training_session).permit(:user_id, :training_session_id, :payment_method, :paid)
  end
end
