class VideoNotifierMailer < ApplicationMailer
    default from: 'info@a1genius.com'
    
    def send_video_email(video)
      @video = video
      mail( to: @video.email,
      subject: 'Here is your video link:' + @video.video )
    end
end
