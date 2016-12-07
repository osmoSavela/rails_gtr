class Admin::TrainingClassesController < Admin::AdminController

  def show
    @training_class = TrainingClass.find(params[:id])
  end

  def new
    @training_class = TrainingClass.new
  end

  def edit
    @training_class = TrainingClass.find(params[:id])
  end

  def update
    @training_class = TrainingClass.find(params[:id])
    respond_to do |format|
      if @training_class.update(training_class_params)
        format.html {redirect_to admin_training_classes_url}
      end
    end
  end

  def create
    @training_class = TrainingClass.new(training_class_params)

    respond_to do |format|
      if @training_class.save
        format.html{redirect_to admin_training_classes_url}
      end
    end
  end

  def destroy
    @training_class = TrainingClass.find(params[:id])
    @training_class.destroy

    redirect_to admin_training_classes_url
  end

  def index
    @training_classes = TrainingClass.all
  end



  private

  def training_class_params
      params.require(:training_class).permit(:name, :moniker, :price, :description, :ammo_requirement, :credential_requirement, :equipment_requirement, :foid_required, :active)
  end
end
