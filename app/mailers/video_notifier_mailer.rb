class VideoNotifierMailer < ApplicationMailer
  default from: 'trendi@a1genius.com'

  def send_video_email(video)
    @video = video
    mail( to: @video.email,
          subject: 'Food Waste')
  end
end
