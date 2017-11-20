class VideosController < ApplicationController
  before_action :require_user
  before_action :set_video, only: [:show]
  
  def index
    @categories = Category.all
  end

  def show
    @reviews = @video.reviews
  end

  def search
    @results = Video.search_by_title(params[:search_term])
  end

  def advanced_search
    options = {
      reviews: params[:reviews],
      rating_from: params[:rating_from],
      rating_to: params[:rating_to]
    }

    if params[:query]
      @videos = Video.search(params[:query], options).records.to_a
    else
      @videos = []
    end
  end

  private

  def set_video
    @video = VideoDecorator.decorate(Video.find(params[:id]))
  end
end
