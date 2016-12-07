class UserMailer < ActionMailer::Base
  default from: "GTRTeam@gtrsport.com"


  def failed_payment(user)
    @user = user
    mail to: 'memberships@gtrsport.com', subject: "Membership payment failed"
  end

  def admin_membership_confirmation(user)
    @user = user
    mail to: "memberships@gtrsport.com", subject: 'New Membership for GTR'
  end

  def admin_class_registration(user_training_session)
    @user = user_training_session.user
    @session = user_training_session.training_session
    @training_class = user_training_session.training_session.training_class

    mail to: "memberships@gtrsport.com", subject: 'New Class Registration'
  end

  def signup_confirmation(user)
    @user = user

    mail to: user.email, subject: 'Welcome to GTR Sporting'
  end

  def admin_created_account(user)
    @user = user
    mail to: user.email, subject: 'Your GTR Sporting Club Account'
  end


  def reservation_email(master_reservation)
    @user = master_reservation.user
    @master_reservation = master_reservation
    @first_reservation = @master_reservation.reservations.first

    mail to: @user.email, subject: 'Reservation Confirmation'
  end

  def payment_confirmation(payment)
    @user = payment.user
    @payment = payment


    mail to: @user.email, subject: 'Payment Confirmation'
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.session_registration_confirmation.subject
  #
  def session_registration_confirmation(user, session)
    @user = user
    @session = session

    mail to: user.email, subject: "You have registered for #{session.training_class.name}"
  end
end
