class Admin::UserTrainingSessionsController < Admin::AdminController
  before_filter :make_sure_user_doesnt_exist, on: [:create]
  
  def make_sure_user_doesnt_exist
    if User.find_by_email(params[:email])
      redirect_to :back, notice: 'A user with this email already exists in the system. Please use another email.'
    end
  end
  
	def new
		@user_training_session = UserTrainingSession.new
		@training_session = TrainingSession.find(params[:training_session])

	end

	def create
		@user_training_session = UserTrainingSession.new(user_training_session_params)
		if params[:new_user].present?
			user = User.admin_create_user(params[:first_name], params[:last_name], params[:email])
			@user_training_session.user_id = user.id
		else
			email = params[:user_training_session][:user_email].split.last
			@user_training_session.user_id = User.find_by_email(email).id
		end
		if @user_training_session.save
			if params[:new_user]
				UserMailer.admin_created_account(@user_training_session.user).deliver
			end
			respond_to do |format|
				format.html{redirect_to admin_training_session_url(@user_training_session.training_session), notice: "User added to class!"}
			end

		else
			respond_to do |format|
				format.html{redirect_to :back, notice: "Oops, that didn't work. Please try again."}
			end
		end
	end

	def edit

	end

	def update
		@user_training_session = UserTrainingSession.find(params[:id])
		if @user_training_session.update(user_training_session_params)
			respond_to do |format|
				format.js
				format.html{redirect_to admin_training_session_url(@user_training_session.training_session)}
			end
		end
	end

	def show

	end

	private

	def user_training_session_params
		params.require(:user_training_session).permit(:training_session_id, :user_id, :payment_method, :paid)
	end
end
