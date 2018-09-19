class Api::V1::GroupsController < Api::V1::ApiController
  respond_to :json

  before_action :current_user, except: [:create]
  before_action :set_group, only: [:show, :edit, :posts, :update, :destroy, :like, :dislike, :leave]

  def index
    @groups = Group.all.order(created_at: :desc)
    json_groups = @groups.as_json
    json_groups.each_with_index do |group, i|
      if current_user.id == group['user_id']
        group['is_register'] = true
      else
        group['is_register'] = false
      end
      group['picture'] = @groups[i].avatar.url
    end
    render :json => { groups: json_groups, status: :ok }
  end

  def show
    @members = members_list
    @requests = requests_list
    render json: {
      group: @group,
      posts: @group.posts,
      members: @members,
      requests: @requests,
      status: :ok
    }
  end

  def posts
    posts = @group.posts
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


  def new
    @group = Group.new
  end

  def create
    if params != nil
      @group = Group.new(group_params(params))

      if @group != nil
        @group.save!

        render json: @group, status: 200
      else
        render json: @group.errors, status: 422
      end
    end
  end

  def edit
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    if @group.update(group_params(params))
      render json: @group, status: 200
    else
      render :json => @group.errors, :status => 422
    end
  end


  def destroy
    @group.destroy
    render json: {
      status: 200,
      message: 'Group deleted'
    }
  end

  def like
    @group.liked_by current_user
    render json: {
      status: 200
    }
  end

  def dislike
    @group.unliked_by current_user
    render json: {
      status: 200
    }
  end

  def leave
    if !@group.nil?
      if @group.try(:member_requests).find_by_user_id(current_user.id)
        if @group.destroy
          render json: {
            status: 200,
            message: 'You successfully left this group'
          }
        else
          render json: {
            status: 422,
            message: 'You canno\'t quit this group for the moment'
          }
        end
      else
        render json: {
          status: 422,
          message: 'You don\'t belong to this group'
        }
      end
    else
      render json: {
        status: 422,
        message: 'This group doesn\'t exist'
      }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_group
    @group = Group.find_by_id(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def group_params(parameters)
    data = {}
    data[:user_id] = current_user.id
    data[:name] = parameters[:name] || "untitle"
    data[:description] = parameters[:description] || "Pas de description"
    data[:private_status] = parameters[:private_status] || false
    data
  end

  def members_list
    @data_members = []
    @group.members.each do |member|
      @data_members << {
        user: User.find(member.user_id).slice('id', 'firstname', 'lastname')
      }
    end
    @data_members
  end

  def requests_list
    @data_requests = []
    @group.pending_requests.each do |request|
      @data_requests << {
        user: User.find(request.user_id).slice('id', 'firstname', 'lastname')
      }
    end
    @data_requests
  end

  # DOCUMENTATION
  include Swagger::Blocks

  swagger_path '/api/v1/groups' do
    operation :post do
      key :description, 'Create a group'
      key :operationId, 'addGroup'
      key :produces, [
        'application/json'
      ]
      key :tags, [
        'group'
      ]
      parameter do
        key :name, :id
        key :name, :string
        key :private, :boolean
        key :user_id, :integer
        schema do
          key :'$ref', :GroupInput
        end
      end
      response 200 do
        key :description, 'Group created'
        schema do
          key :'$ref', :Group
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
  swagger_path 'api/v1/groups/{id}' do
    operation :get do
      key :description, 'Get group information, profile'
      key :operationId, 'getGroup'
      key :tags, [
        'group'
      ]
      parameter do
        key :name, :id
        key :in, :path
        key :description, 'Id of Group to fetch'
        key :required, true
        key :type, :integer
        key :format, :int64
      end
      response 200 do
        key :description, 'Group response'
        schema do
          key :'$ref', :Group
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
  swagger_path 'api/v1/groups/{id}' do
    operation :put do
      key :description, 'Upload Group'
      key :operationId, 'uploadGroup'
      key :tags, [
        'group'
      ]
      key :produces, [
        'application/json'
      ]
      parameter do
        key :name, :id
        key :in, :path
        key :description, 'Id of group to fetch'
        key :required, true
        key :type, :integer
        key :format, :int64
      end
      parameter do
        key :name, :string
        key :private, :boolean
      end
      response 200 do
        key :description, 'Group response'
        schema do
          key :'$ref', :Group
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
  swagger_path 'api/v1/groups/{id}' do
    operation :delete do
      key :description, 'Delete group'
      key :operationId, 'deleteGroup'
      key :tags, [
        'group'
      ]
      parameter do
        key :name, :id
        key :in, :path
        key :description, 'Id of group to fetch'
        key :required, true
        key :type, :integer
        key :format, :int64
      end
      response 200 do
        key :description, 'Group response'
        schema do
          key :'$ref', :Group
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
