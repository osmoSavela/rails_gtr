class Admin::InstructorsController < Admin::AdminController
  def new
    @instructor = Instructor.new
  end

  def create
    @instructor = Instructor.new(instructor_params)

    respond_to do |format|
      if @instructor.save
        format.html {redirect_to admin_instructors_url, notice: 'Instructor Succesfully Added.'}
      else
        format.html {redirect_to :back, notice: 'Something Went Wrong, Please Try Again.'}
      end
    end
  end

  def edit
    @instructor = Instructor.find(params[:id])
  end

  def update
    @instructor = Instructor.find(params[:id])
    if params[:instructor][:remove_image].present?
      @instructor.remove_image!
    end
    respond_to do |format|
      if @instructor.update(instructor_params)
        format.html {redirect_to admin_instructors_url, notice: 'Instructor Successfully Updated'}
      end
    end
  end

  def destroy
    @instructor = Instructor.find(params[:id])
    @instructor.destroy

    respond_to :js
  end

  def show
  end

  def index
    @instructors = Instructor.all
  end

  private

  def instructor_params
    params.require(:instructor).permit(:first_name, :last_name, :email, :bio, :image, :remove_image)
  end
end
