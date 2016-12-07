class Instructor < ActiveRecord::Base

	##### UPLOADER ########################

	mount_uploader :image, ImageUploader

	#####################################

	has_many :training_sessions

	def full_name
		"#{first_name} #{last_name}"
	end

	def next_upcoming_session
		training_sessions.current.order(:session_date).first
	end
end
