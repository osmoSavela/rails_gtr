class Admin::HomepageVideosController < ApplicationController
  def create
    @homepage_video = HomepageVideo.new(homepage_video_params)
    if @homepage_video.save
      respond_to do |format|
        format.html {redirect_to admin_homepage_videos_url, notice: "You have succesffully created a homepage video for #{@homepage_video.training_class.name}"}
      end
    end
  end

  def new
    @homepage_video = HomepageVideo.new
  end

  def edit
    @homepage_video = HomepageVideo.find(params[:id])

  end

  def update
    @homepage_video = HomepageVideo.find(params[:id])
    url = params[:homepage_video][:url]
    url = url.gsub('watch?v=', 'embed/')
    url = url + "?rel=0&amp;showinfo=0"
    @homepage_video.url = url

    respond_to do |format|
      if @homepage_video.save
        format.html {redirect_to admin_dashboard_url, notice: "homepage video successfully updated."}
      else
        format.html {redirect_to :back, notice: "Oops, that didn't work. Please try again."}
      end
    end
  end

  def destroy
    @homepage_video = HomepageVideo.find(params[:id])
    @homepage_video.destroy

    respond_to :js
  end

  def index
    @homepage_videos = HomepageVideo.all
  end


  private

  def homepage_video_params
    params.require(:homepage_video).permit(:url)
  end

end
