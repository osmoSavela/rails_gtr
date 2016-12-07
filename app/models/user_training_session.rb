class UserTrainingSession < ActiveRecord::Base
	belongs_to :training_session
	belongs_to :user

  validates_presence_of :user_id, :training_session_id

	after_create :add_attendee_to_session
	after_create :send_admin_email

	def send_admin_email
		UserMailer.admin_class_registration(self).deliver
	end

	def user_email
		user.try(:email)
	end

	def user_email=(email)
		self.user = User.find_by_last_email(email) if email.present?
	end

	def add_attendee_to_session
		training_session.add_attendee
	end
end
