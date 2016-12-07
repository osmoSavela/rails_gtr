# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/signup_confirmation
  def signup_confirmation
    UserMailer.signup_confirmation
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/session_registration_confirmation
  def session_registration_confirmation
    UserMailer.session_registration_confirmation
  end

end
