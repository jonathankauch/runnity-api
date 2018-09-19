class RegistrationsController < Devise::RegistrationsController
  before_action :set_user, only: [:edit, :update]

  def edit
  end

  def update
    if @user.update(sign_up_params)
      redirect_to user_show_url(@user), notice: 'User was successfully updated.'
    else
      redirect_to edit_user_registration_path(@user), notice: "Something broke #{@user.errors.messages.inspect}"
    end
  end

  def upload_pics(picture)
    bucket = ENV['S3_BUCKET']
    pic = picture
    content_type = pic.content_type.split('/').last

    if content_type == 'jpeg'
      content_type = 'jpg'
    end

    s3 = Aws::S3::Client.new(region: 'us-west-2')
    md5 = Digest::MD5.file(picture.tempfile).hexdigest
    filename = md5 + '.' + content_type
    s3.put_object(bucket: bucket, key: 'pictures/' + filename, body: pic,
                  acl: 'public-read', content_type: pic.content_type)
    link = 'https://s3-us-west-2.amazonaws.com/' + bucket + '/pictures/' + filename
    # @post.picture = link
    # picture = AwsUploadFile.new(params[:post][:picture]).upload
    # @user.pictures.new(name: filename, url: link)
    {
      filename: filename,
      url: link
    }
  end

  private

  def set_user
    @user = current_user
  end

  def sign_up_params
    params.require(:user).permit(:firstname, :lastname, :phone,
                                 :address, :email, :password, :password_confirmation,
                                 :weight, :avatar, :description).reject{ |k,v| v.blank? }
  end

  def account_update_params
    params.require(:user).permit(:firstname, :lastname, :phone, :address, :email, :weight)
  end

end
