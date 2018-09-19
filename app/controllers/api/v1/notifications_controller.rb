class Api::V1::NotificationsController < Api::V1::ApiController
  respond_to :json
  before_action :current_user

  def index
    group_notifications = current_user.groups_notifications
    event_notifications = current_user.events_notifications
    friends_notifications = current_user.friendship_requests

    render json: {
      groups: group_notifications,
      events: event_notifications,
      friends: friends_notifications,
      status: :ok
    }
  end
end
