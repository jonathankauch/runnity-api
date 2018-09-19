class PostsController < ApplicationController
  before_action :authenticate_user!, :current_user
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.order(created_at: 'DESC').limit(5)
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    if params[:posts].nil?
      @post = Post.new(post_params)
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
        params[:post][:picture].tempfile.rewind
        s3.put_object(bucket: bucket, key: 'pictures/' + filename, body: pic,
                      acl: 'public-read', content_type: pic.content_type)
        link = 'https://s3-us-west-2.amazonaws.com/' + bucket + '/pictures/' + filename
        @post.picture = link
        # picture = AwsUploadFile.new(params[:post][:picture]).upload
        @post.pictures.new(name: filename, url: link)
      end
    else
      @post = Post.new(params[:post])
    end

    if @post.save
      redirect_to :back
    else
      redirect_to :back
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    if current_user.id != @post.user.id
      flash[:alert] = "Not authorized"
      respond_to do |format|
        format.html { redirect_to @post }
        format.json { render json: { error: 'Not allowed', status: 401 }}
      end
    end

    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # POST /posts/status
  def switch_private_status
    @post.change_post_private_status
    respond_to do |format|
      if @post.save
        format.json { head :no_content }
      else
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def like
    @post = Post.find(params[:id])
    @post.liked_by current_user
    redirect_to :back
  end

  def dislike
    @post = Post.find(params[:id])
    @post.unliked_by current_user
    redirect_to :back
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:content, :picture, :user_id, :event_id, :group_id)
    end
end
