class Admin::AdminController < ApplicationController

  before_action :require_admin

end
