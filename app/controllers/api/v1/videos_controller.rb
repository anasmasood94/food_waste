class Api::V1::VideosController < Api::V1::ApiController

  def create
    video = Video.new create_params
    if video.save
      VideoNotifierMailer.send_video_email(video).deliver_now
      render json: { success: true }.to_json, status: 200
    else
      render json: { success: false, message: video.errors.full_messages.frist }.to_json, status: 422
    end
  end
  

  private

  def create_params
    params.permit(:email, :number).merge(video: upload_video_to_s3)
  end

  def upload_video_to_s3
    object = get_s3_object
    object.upload_file(params[:video].path, acl: "public-read", content_type: "video/mp4")
    object.public_url
  end

  def get_object_key
    "#{File.basename(params[:video].path, ".*")}-#{Date.today.to_s}.#{File.extname(params[:video].path)}"
  end

  def get_s3_object
    Aws::S3::Resource.new(
      access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_SECRET_ACESS_KEY'],
    region: ENV['AWS_REGION']).bucket(ENV['AWS_BUCKET']
                                      ).object(get_object_key)
  end

end
