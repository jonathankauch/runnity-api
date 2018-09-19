class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    @post = Post.new
    if !current_user.nil?
      @run = @user.runs.last
      @posts = Post.where(user_id: @user.id).order(created_at: :desc)
    end
  end

  # POST
  def upload_pics
    if !params[:post][:picture].nil?
      # picture = AwsUploadFile.new(params[:post][:picture]).upload
      bucket = ENV['S3_BUCKET']
      pic = params[:post][:picture]
      content_type = pic.content_type.split('/').last

      if content_type == 'jpeg'
        content_type = 'jpg'
      end

      s3 = Aws::S3::Client.new(region: 'us-west-2')
      md5 = Digest::MD5.file(params[:post][:picture].tempfile).hexdigest
      filename = md5 + '.' + content_type
      s3.put_object(bucket: bucket, key: 'pictures/' + filename, body: pic,
                    acl: 'public-read', content_type: pic.content_type)
      link = 'https://s3-us-west-2.amazonaws.com/' + bucket + '/pictures/' + filename
      # @post.picture = link
      # picture = AwsUploadFile.new(params[:post][:picture]).upload
      @post.pictures.new(name: filename, url: link)
    end
  end

end
