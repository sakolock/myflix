class Admin::VideosController < AdminsController
  before_action :require_user

  def new
    @video = Video.new
  end

  def create
    @video = Video.create(video_params)
    if @video.save
      flash[:success] = "You have successfully added #{@video.title}"
      redirect_to new_admin_video_path
    else
      flash[:error] = "Please check the inputs"
      render :new
    end
  end

  private

  def video_params
    params.require(:video).permit(:title, :category_id, :description, :large_cover, :small_cover, :video_url)
  end
end
