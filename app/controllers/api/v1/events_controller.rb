class Api::V1::EventsController < Api::V1::ApiController
  respond_to :json

  # before_action :current_user, except: [:create]
  before_action :authenticate_user!, :current_user
  before_action :set_event, only: [:show, :posts, :edit, :update, :destroy,
                                   :like, :dislike]

  def index
    @events = Event.all.order(created_at: :desc)
    # @elikes = @events.get_likes
    # @events = @events.as_json
    tmp = []
    toto = []
    @events.each_with_index do |event, i|
      names = []
      event.get_likes.each do |like|
        names << User.find_by_id(like.voter_id).fullname
      end
      if current_user.liked? event
        tmp << {'is_register': true, liked_by: names}
      else
        tmp << {'is_register': false, liked_by: names}
      end
    end

    json_events = @events.as_json
    json_events.each_with_index do |event, i|
      event['is_register'] = tmp[i][:is_register]
      event['liked_by'] = tmp[i][:liked_by]
      event['picture'] = @events[i].avatar.url
    end

    render :json => { events: json_events, status: :ok }
  end

  def show
    render json: {
      event: @event,
      picture: @event.avatar.url,
      status: :ok
    }
  end

  def posts
    posts = @event.posts.order(created_at: :desc)
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
    @event = event.new
  end

  def create
    if params != nil
      @event = Event.new(event_params(params))
      if @event.save
        render json: @event, status: 200
      else
        render json: @event.errors, status: 422
      end
    end
  end

  def edit
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    if @event.update(event_params(params))
      render json: @event, status: 200
    else
      render :json => @event.errors, :status => 422
    end
  end


  def destroy
      if @event.destroy
        render json: { status: 200, message: 'Event deleted' }
      else
        render :json => @event.errors, :status => 422
      end
  end

  def like
    @event.liked_by current_user
    render json: { message: 'Event joined'}, status: 200
  end

  def dislike
    @event.disliked_by current_user
    render json: { message: 'Event unjoined'}, status: 200
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find_by_id(params[:id])
      render json: { error: 'Event not found'}, status: 404 if @event.nil?
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params(parameters)
      data = {}
      data[:user_id] = current_user.id
      data[:name] = parameters[:name] || "untitle"
      data[:private_status] = parameters[:private_status] || false
      data[:distance] = parameters[:distance] || 10
      data[:city] = parameters[:city] || "Paris"
      data[:start_date] = parameters[:start_date] || Date.today
      data[:end_date] = parameters[:end_date] || Date.tomorrow.at_end_of_day
      data[:description] = parameters[:description] || ""
      data
    end

  # DOCUMENTATION
  include Swagger::Blocks

  swagger_path '/api/v1/events' do
    operation :post do
      key :description, 'Create an event'
      key :operationId, 'addEvent'
      key :produces, [
        'application/json'
      ]
      key :tags, [
        'event'
      ]
      parameter do
        key :name, :id
        key :name, :string
        key :description, :string
        key :start_date, :dateTime
        key :end_date, :dateTime
        key :city, :string
        key :private, :boolean
        key :distance, :integer
        key :user_id, :integer
        schema do
          key :'$ref', :EventInput
        end
      end
      response 200 do
        key :description, 'event created'
        schema do
          key :'$ref', :Event
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
  swagger_path 'api/v1/events/{id}' do
    operation :get do
      key :description, 'Get event information, profile'
      key :operationId, 'getevent'
      key :tags, [
          'event'
      ]
      parameter do
        key :name, :id
        key :in, :path
        key :description, 'Id of event to fetch'
        key :required, true
        key :type, :integer
        key :format, :int64
      end
      response 200 do
        key :description, 'event response'
        schema do
          key :'$ref', :Event
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
  swagger_path 'api/v1/events/{id}' do
    operation :put do
      key :description, 'Upload event information'
      key :operationId, 'uploadevent'
      key :tags, [
        'event'
      ]
      key :produces, [
        'application/json'
      ]
      parameter do
        key :name, :id
        key :in, :path
        key :description, 'Id of event to fetch'
        key :required, true
        key :type, :integer
        key :format, :int64
      end
      parameter do
        key :name, :string
        key :description, :string
        key :start_date, :dateTime
        key :end_date, :dateTime
        key :city, :string
        key :private, :boolean
        key :distance, :integer
        key :user_id, :integer
      end
      response 200 do
        key :description, 'event response'
        schema do
          key :'$ref', :Event
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
  swagger_path 'api/v1/events/{id}' do
    operation :delete do
      key :description, 'Delete events'
      key :operationId, 'deleteEvent'
      key :tags, [
          'event'
      ]
      parameter do
        key :name, :id
        key :in, :path
        key :description, 'Id of the event to fetch'
        key :required, true
        key :type, :integer
        key :format, :int64
      end
      response 200 do
        key :description, 'Event response'
        schema do
          key :'$ref', :Event
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
