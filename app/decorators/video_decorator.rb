class VideoDecorator < Draper::Decorators
  delegate_all

  def rating
    object.rating.present? ? "#{object.rating}/5.0" : "N/A"
  end
end
