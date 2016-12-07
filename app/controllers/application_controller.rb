class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  skip_before_action :ez_update_tables

  
  
  def require_login
    redirect_to root_url, notice: "Please sign in or sign up." unless user_signed_in?
  end

  def require_admin
    redirect_to root_url, notice: "You are not authorized to view that page." unless admin?
  end


  def admin?
    user_signed_in? && current_user.try(:admin) == true
  end

  def redirect_to_under_construction
    redirect_to under_construction_url
  end

end
