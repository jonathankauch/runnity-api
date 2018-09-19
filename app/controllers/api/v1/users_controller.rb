class Api::V1::UsersController < Api::V1::ApiController
  respond_to :json

  before_action :current_user, except: [:create]
  before_action :set_user, only: [:show, :update, :destroy, :notifications]

  def index
    @users = User.all
    render :json => { users: @users, status: :ok }
  end

  def show
    posts = Post.where(user_id: @user.id).order(created_at: :desc)
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
    end

    render json: {
      user: @user,
      picture: @user.avatar.url,
      posts: json_posts,
      friends: @user.friends,
      notifications: all_notifications,
      status: :ok
    }
  end

  def new
    @user = User.new
  end

  def create
    if params != nil
      @user = User.new(user_params(params))

      if @user != nil
        @User.save!

        render json: @user, status: 200
      else
        render json: @user.errors, status: 422
      end
    end
  end

  def edit
  end

  def update
    if @user.update(user_params(params))
      render json: @user, status: 200
    else
      render json: {message: 'Error'}, status: 422
    end
  end

  def destroy
    @user.destroy
    render json: {
      status: 200,
      message: 'user deleted'
    }
  end

  def notifications
    render json: {
      status: 200,
      notifications: all_notifications
    }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params(parameters)
      params.require(:user).permit(:firstname, :lastname, :phone, :address, :enable, :weight, :latitude, :longitude, :alone, :description)
    end

    def all_notifications()
      return {
        group_notifications: @user.groups_notifications,
        event_notifications: @user.events_notifications,
        friends_notifications: @user.friendship_requests,
      }
    end
  # DOCUMENTATION
  include Swagger::Blocks

  swagger_path '/api/v1/users' do
    operation :post do
      key :description, 'Create an user'
      key :operationId, 'addUser'
      key :produces, [
        'application/json'
      ]
      key :tags, [
        'user'
      ]
      parameter do
        key :name, :id
        key :firstname, :string
        key :lastname, :string
        key :email, :string
        key :phone, :string
        key :address, :string
        key :enable, :boolean
        key :password, :string
        schema do
          key :'$ref', :UserInput
        end
      end
      response 200 do
        key :description, 'User created'
        schema do
          key :'$ref', :User
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
  swagger_path 'api/v1/users/{id}' do
    operation :get do
      key :description, 'Get user information, profile'
      key :operationId, 'getUser'
      key :tags, [
          'user'
      ]
      parameter do
        key :name, :id
        key :in, :path
        key :description, 'Id of user to fetch'
        key :required, true
        key :type, :integer
        key :format, :int64
      end
      response 200 do
        key :description, 'User response'
        schema do
          key :'$ref', :User
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
  swagger_path 'api/v1/users/{id}' do
    operation :put do
      key :description, 'Upload user information'
      key :operationId, 'uploadUser'
      key :tags, [
        'user'
      ]
      key :produces, [
        'application/json'
      ]
      parameter do
        key :name, :id
        key :in, :path
        key :description, 'Id of user to fetch'
        key :required, true
        key :type, :integer
        key :format, :int64
      end
      parameter do
        key :firstname, :string
        key :lastname, :string
        key :email, :string
        key :phone, :string
        key :address, :string
        key :enable, :boolean
        key :password, :string
      end
      response 200 do
        key :description, 'User response'
        schema do
          key :'$ref', :User
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
