class TrainingSession < ActiveRecord::Base
	belongs_to :training_class
	belongs_to :instructor
	has_many :user_training_sessions, dependent: :destroy
  has_many :payments, as: :paymentable
  
  validates_presence_of :training_class_id, :session_date, :start_time, :end_time

  after_create :send_user_email

  extend SimpleCalendar

  has_calendar :attribute => :session_date

  scope :current, -> { where("session_date is not null AND session_date >= ?", Date.today)}

  def add_attendee
  	self.quantity_available -= 1
  	self.save
  end

  def price_for(user)
    class_price = self.training_class.price
    if user.membership.present?
      membership = user.membership
      discount_percent = membership.training_discount / 100.00
      return class_price - (class_price*discount_percent)
    else
      return self.training_class.price
    end

  end

  def payment_for(user)
    return payments.find_by(user_id: user.id) if payments.find_by(user_id: user.id).present?
  end

  def send_user_email
    UserMailer.session_registration_confirmation(self.user, self).deliver
  end


end
