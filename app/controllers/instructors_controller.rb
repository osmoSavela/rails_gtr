class InstructorsController < ApplicationController
  def show
  	@instructor = Instructor.find(params[:id])
  end

  def index
  	@instructors = Instructor.all
  end
end
