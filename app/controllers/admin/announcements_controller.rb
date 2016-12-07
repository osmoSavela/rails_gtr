class Admin::AnnouncementsController < Admin::AdminController

  def new
    @announcement = Announcement.new
  end

  def create
      @announcement = Announcement.new(announcement_params)

    respond_to do |format|
      if @announcement.save
        format.html {redirect_to admin_announcements_url, notice: 'Announcement created successfully.'}
      else
        format.html {redirect_to :back, notice: "Oops that didn't work. Please try again."}
      end
    end

  end

  def index
    @announcements = Announcement.order('created_at desc')
  end

  def edit
    @announcement = Announcement.find(params[:id])
  end

  def update
    @announcement = Announcement.find(params[:id])

    respond_to do |format|
      if @announcement.update(announcement_params)
        format.html { redirect_to admin_announcements_url, notice: 'Announcement was successfully updated.' }
      else
        format.html { render action: 'edit' }
        format.json { render json: @announcement.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @announcement = Announcement.find(params[:id])
    respond_to do |format|
      if @announcement.destroy
        format.html { redirect_to admin_announcements_url, notice: 'Announcement was deleted.' }
      else
        format.html { redirect_to admin_announcements_url, notice: "Oops that didn't work! Please try again." }
      end
    end
  end

  private

  def announcement_params
    params.require(:announcement).permit(:content, :active)
  end




end
