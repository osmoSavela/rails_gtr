class Users::RegistrationsController < Devise::RegistrationsController

  # before_action :redirect_to_under_construction

  before_filter :configure_permitted_parameters

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up).push(:first_name, :last_name, :email, :city, :address1, :address2, :state, :zip, :foid_or_license)
  end


end
