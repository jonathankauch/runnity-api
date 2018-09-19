class Api::V1::FriendshipsController < Api::V1::ApiController
  respond_to :json

  before_action :current_user
  before_action :set_user_by_email, only: [:create]
  before_action :set_user, only: [:accept, :reject, :destroy]

  def index
    @friends = friends_list
    @requests = requests_list
    @notifications = notifications_list
    render json: {
      friends: @friends,
      requests: @requests,
      notifications: @notifications,
      status: :ok
    }
  end

  def show
  end

  def create
    if current_user.friend_request(@user)
      render json: {
         status: 200,
         message: 'Request created'
      }
    else
      render json: {
        status: 422,
        message: 'Request failed'
      }
    end
  end

  def accept
     if current_user.accept_request(@user)
      render json: {
         status: 200,
         message: 'Request accepted'
      }
     else
      render json: {
        status: 422,
        message: 'Request failed'
      }
    end
  end

  def reject
    if current_user.decline_request(@user)
      render json: {
        status: 200,
        message: 'Request declined'
      }
    else
      render json: {
        status: 422,
        message: 'Request failed'
      }
    end
  end

  def notifications
    @notifications = notifications_list
    render json: {
      notifications: @notifications,
      status: :ok
    }
  end

  def destroy
    if current_user.remove_friend(@user)
      render json: {
        status: 200,
        message: 'Friend deleted'
      }
    else
      render json: {
        status: 422,
        message: 'Canno\'t delete this friend'
      }
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_user_by_email
    @user = User.find_by_email(params[:email])
  end

  def friends_list
    @data_friends = []
    current_user.friends.each do |friend|
      @data_friends << friend.friend.attributes.slice('id', 'firstname', 'lastname').merge(friend_request_id: friend.id)
    end
    @data_friends
  end

  def requests_list
    @data_requests = []
    current_user.friendship_requests.each do |request|
      @data_requests << request.friend.attributes.slice('id', 'firstname', 'lastname').merge(requests_id: request.id)
    end
    @data_requests
  end

  def notifications_list
    @data_notifications = []
    current_user.notifications.each do |notification|
      @data_notifications << notification.attributes.slice('id', 'user_id', 'read').merge(notification_id: notification.id)
    end
    @data_notifications
  end
end
