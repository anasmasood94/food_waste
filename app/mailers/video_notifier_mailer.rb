class VideoNotifierMailer < ApplicationMailer
  default from: 'marketing@trendi.com'

  def send_video_email(video)
    @video = video
    mail( to: @video.email,
          subject: 'Food Waste')
  end
end
