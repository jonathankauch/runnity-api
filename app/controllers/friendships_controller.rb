class FriendshipsController < ApplicationController
  before_action :current_user
  before_action :set_user

  def index
    @friends = current_user.friends
  end

  def show
  end

  def create
    if current_user.friend_request(@user)
      respond_to do |format|
        format.js
      end
    end
  end

  def accept
    if current_user.accept_request(@user)
      current_user.create_friend_notification(@user.id, "accepted")
      respond_to do |format|
        format.js
      end
    end
  end

  def reject
    respond_to do |format|
      if current_user.decline_request(@user)
        format.js
      end
    end
  end

  def destroy
    respond_to do |format|
      if current_user.remove_friend(@user)
        format.js
      end
    end
  end

  private
  def set_user
    @user = User.find(params[:user_id])
  end

end
