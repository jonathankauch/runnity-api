class Api::V1::PostsController < Api::V1::ApiController
  respond_to :json

  before_action :authenticate_user!, :current_user
  before_action :set_post, only: [:show, :edit, :update, :destroy, :switch_private_status, :like, :dislike]

  # GET /posts
  # GET /posts.json
  def index
    posts = Post.order(created_at: :desc)
    tmp_posts = []
    posts.each do |post|
      tmp_comments = []
      tmp_post = post.attributes
      post.comments.each do |comment|
        tmp_comment = comment.attributes
        tmp_comment["user_fullname"] = comment.user.fullname
        tmp_comments << tmp_comment
      end
      tmp_post["comments"] = tmp_comments
      tmp_post["user"] = {
        user_id: post.user.id,
        full_name: post.user.fullname
      }
      tmp_posts << tmp_post
    end

    json_posts = tmp_posts.as_json
    json_posts.each_with_index do |post, i|
      if !posts[i].pictures.first.nil?
        post['picture'] = posts[i].pictures.first.url
      else
        post['picture'] = posts[i].picture
      end
      post['likes'] = posts[i].votes_for.size
      post['is_liked'] = current_user.voted_for?(posts[i])
    end

    render :json => { posts: json_posts, status: :ok }
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
    if @post = @current_user.posts.new(post_params)
      if @post.save
        if !params[:picture].nil?
          picture = AwsUploadFile.new(params[:picture]).upload
          @pic = @post.pictures.create(name: picture[:name] || "no_name", url: picture[:url])
          @post.update_attributes(:picture => @pic.url)
        else
          puts params.inspect
          puts @post.errors.inspect
          render :json => "Empty picture", :status => 422 and return
        end
        render json: @post, status: 200 and return
      else
        puts @post.errors.inspect
        logger.error(@post.errors)
        render :json => @post.errors, :status => 422 and return
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    if @post.update(post_params)
      render json: @post, status: 200
    else
      render :json => @post.errors, :status => 422
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    if @post.user == current_user
      if @post.destroy
        render json: {
          status: 200,
          message: 'Post deleted'
        }
      else
        render :json => @post.errors, :status => 422
      end
    else
      render :json => {msg: 'error'}, :status => 422
    end
  end

  # POST /posts/status
  def switch_private_status
    if @post.update(private: !@post.private)
      render :json => @post, :status => 200
    else
      render :json => @post.errors, :status => 422
    end
  end

  def like
    @post = Post.find(params[:id])
    @post.liked_by current_user
    render json: { msg: 'success' }
  end

  def dislike
    @post = Post.find(params[:id])
    @post.unliked_by current_user
    render json: { msg: 'success' }
  end

  # POST /posts/:id/addpicture
  def add_picture_to_post
    @post = Post.find_by_id(params[:id])
    if !params[:picture].nil?
      picture = AwsUploadFile.new(params[:picture]).upload
      @pic = @post.pictures.create(name: picture[:name] || "no_name", url: picture[:url])
      @post.update_attributes(:picture => @pic.url)
      render :json => @pic, :status => 200
    else
      render :json => "Empty picture", :status => 422
    end
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


  # DOCUMENTATION
  include Swagger::Blocks

  swagger_path '/api/v1/posts' do
    operation :post do
      key :description, 'Create a post'
      key :operationId, 'addPost'
      key :produces, [
        'application/json'
      ]
      key :tags, [
        'post'
      ]
      parameter do
        key :name, :id
        key :content, :string
        key :picture, :string
        key :user_id, :integer
        key :event_id, :integer
        key :group_id, :integer
        schema do
          key :'$ref', :PostInput
        end
      end
      response 200 do
        key :description, 'Post created'
        schema do
          key :'$ref', :Post
        end
      end
      response :default do
        key :description, 'unexpected error'
        schema do
          key :'$ref', :ErrorModel
        end
      end
    end
  end
  swagger_path 'api/v1/posts/{id}' do
    operation :get do
      key :description, 'Get post information'
      key :operationId, 'getPost'
      key :tags, [
          'post'
      ]
      parameter do
        key :name, :id
        key :in, :path
        key :description, 'Id of post to fetch'
        key :required, true
        key :type, :integer
        key :format, :int64
      end
      response 200 do
        key :description, 'Post response'
        schema do
          key :'$ref', :Post
        end
      end
      response :default do
        key :description, 'unexpected error'
        schema do
          key :'$ref', :ErrorModel
        end
      end
    end
  end
  swagger_path 'api/v1/posts/{id}/status' do
    operation :get do
      key :description, 'Switch status like or dislike'
      key :operationId, 'statusPost'
      key :tags, [
          'post'
      ]
      parameter do
        key :name, :id
        key :in, :path
        key :description, 'Id of post to fetch'
        key :required, true
        key :type, :integer
        key :format, :int64
      end
      response 200 do
        key :description, 'Post response'
        schema do
          key :'$ref', :Post
        end
      end
      response :default do
        key :description, 'unexpected error'
        schema do
          key :'$ref', :ErrorModel
        end
      end
    end
  end
  swagger_path 'api/v1/posts/{id}' do
    operation :put do
      key :description, 'Upload post'
      key :operationId, 'uploadPost'
      key :tags, [
        'post'
      ]
      key :produces, [
        'application/json'
      ]
      parameter do
        key :name, :id
        key :in, :path
        key :description, 'Id of post to fetch'
        key :required, true
        key :type, :integer
        key :format, :int64
      end
      parameter do
        key :content, :string
        key :picture, :string
        key :user_id, :integer
        key :event_id, :integer
        key :group_id, :integer
      end
      response 200 do
        key :description, 'Post response'
        schema do
          key :'$ref', :Post
        end
      end
      response :default do
        key :description, 'unexpected error'
        schema do
          key :'$ref', :ErrorModel
        end
      end
    end
  end
  swagger_path 'api/v1/posts/{id}' do
    operation :delete do
      key :description, 'Delete post'
      key :operationId, 'deletePost'
      key :tags, [
          'post'
      ]
      parameter do
        key :name, :id
        key :in, :path
        key :description, 'Id of post to fetch'
        key :required, true
        key :type, :integer
        key :format, :int64
      end
      response 200 do
        key :description, 'Post response'
        schema do
          key :'$ref', :Post
        end
      end
      response :default do
        key :description, 'unexpected error'
        schema do
          key :'$ref', :ErrorModel
        end
      end
    end
  end
end
