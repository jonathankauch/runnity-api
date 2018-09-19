class NotificationsController < ApplicationController
  before_action :current_user
  before_action :set_notification, only: [:read]

  def read
    @notification.update(read: true)
    head :no_content
  end

  private
  def set_notification
    @notification = current_user.notifications.where(params[:id])
  end
end
