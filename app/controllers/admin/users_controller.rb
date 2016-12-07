class Admin::UsersController < Admin::AdminController
	respond_to :json, :html, :js

	def new
    @user = User.new

	end

  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update(user_params)
        format.html {redirect_to admin_users_url, notice: 'User successfully updated'}
      else
        format.html {redirect_to admin_users_url, notice: 'Sorry, something went wrong.'}
      end 
    end
  end

	def create
    @user = User.new(user_params)

      @user.password = loop do
        random_token = SecureRandom.urlsafe_base64(nil, false)
        break random_token unless User.exists?(encrypted_password: random_token)
      end

    respond_to do |format|
      if @user.save
        format.html {redirect_to admin_users_url, notice: 'User Successfully created.'}
      else
        format.html {redirect_to :back, notice: @user.errors.full_messages.first}
      end
    end

	end


  def index
  	if params[:term]
    	@users = User.where("lower(last_name) like ?", "%#{params[:term].downcase}%")
    	render json: @users.map{|u| "#{u.full_name} - #{u.email}"}
    elsif params[:search]
      @users = User.where('lower(first_name) like ? or lower(last_name) like ?', "%#{params[:search].downcase}%", "%#{params[:search].downcase}%")
      @users = @users.paginate(page: params[:page], per_page: 50)
    else
    	@users = User.order('last_name asc').paginate(page: params[:page], per_page: 50)
    end

  end

	def destroy
		@user = User.find(params[:id])
		@user.destroy
	end


    private

   # Never trust parameters from the scary internet, only allow the white list through.
   def user_params
     params.require(:user).permit(:first_name, :last_name, :address1, :address2, :email, :phone, :cell_phone, :work_phone, :city, :state, :zip, :dob, :foid_id, :password, :password_confirmation, :hours_available, :guests_left, :foid_or_license, :membership_id)
   end



end
