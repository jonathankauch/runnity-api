class MemberRequestsController < ApplicationController
  before_action :current_user
  before_action :set_user, only: [:create]
  before_action :set_group, only: [:create]
  before_action :set_event, only: [:create]
  before_action :set_member_request, only: [:destroy, :accept, :reject]

  def create
    if !@user.nil?
      @member_invitation = MemberRequest.create(
        :requests_type => @target.capitalize,
        :target        => @target,
        :requests_id   => @content.id,
        :user_id       => @user.id,
        :status        => "waiting"
      )
      if !@member_invitation.nil?
        @content.notifications.create(user_id: @user.id, status: "invitation",  applicant: current_user.id, request_id: @member_invitation.id)
      end
    elsif !params[:email].nil?
      @user_empty = true
    else
      if !@content.nil?
        if @content.private_status
          current_user.member_requests.create(user_id: @content.id, target: @target.capitalize, status: "requested")
        end
        @invitation = @content.member_requests.create(user_id: current_user.id, target: @target.capitalize, status: @content.private_status ? "pending" : "accepted")
        if !@invitation.nil?
          if @content.private_status
            @content.notifications.create(user_id: @content.user_id, status: "pending", applicant: current_user.id, request_id: @invitation.id)
          else
            @content.notifications.create(user_id: current_user.id, status: "accepted")
          end
        end
      end
    end
    respond_to do |format|
      format.js
    end
  end

  def destroy
    respond_to do |format|
      user_request = current_user.try(:member_requests).find_by_user_id(@request.try(:requests_id))
      notification = Notification.find_by_request_id(@request.try(:id))
      if !notification.nil? && !user_request.nil?
        if user_request.destroy && @request.destroy && notification.destroy
          @errors = false
          format.js
        else
          @errors = true
          format.js
        end
      end
    end
  end

  def accept
    respond_to do |format|
      request = MemberRequest.find_by_user_id_and_requests_id(@request.try(:requests_id), @request.try(:user_id))
      if !request.nil?
        request.destroy if @request.status != "waiting"
      end
      if @request.update(:status => "accepted")
        notification = Notification.find_by_id(params[:notification])
        if !notification.nil?
          notification.update(:status => "accepted", :read => true)
        end
        @errors = false
        format.js
      else
        @errors = true
        format.js
      end
    end
  end

  def reject
    respond_to do |format|
      request = MemberRequest.find_by_user_id_and_requests_id(@request.requests_id, @request.user_id)
      if !request.nil?
        request.destroy if @request.status != "waiting"
      end
      if @request.destroy
        Notification.find_by_id(params[:notification]).update(:status => "reject", :read => true)
        @errors = false
        format.js
      else
        @errors = true
        format.js
      end
    end
  end

  private

  def set_event
    if !params[:event_id].nil?
      @content = Event.find_by_id(params[:event_id])
      @target = "event"
    elsif !params[:member_request].nil?
      if params[:member_request][:requests_type] == "event"
        @content = Event.find_by_id(params[:member_request][:requests_id])
        @target = "event"
      end
    end
  end

  def set_group
    if !params[:group_id].nil?
      @content = Group.find_by_id(params[:group_id])
      @target = "group"
    elsif !params[:member_request].nil?
      if params[:member_request][:requests_type] == "group"
        @content = Group.find_by_id(params[:member_request][:requests_id])
        @target = "group"
      end
    end
  end

  def set_user
    if !params[:email].nil?
      @user = User.find_by_email(params[:email])
    end
  end

  def set_member_request
    @request = MemberRequest.find_by_id(params[:id])
  end

end
