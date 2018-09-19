class Api::V1::MemberRequestsController < Api::V1::ApiController
  respond_to :json

  before_action :current_user
  before_action :set_user, only: [:create]
  before_action :set_group, only: [:create]
  before_action :set_event, only: [:create]
  before_action :set_user, only: [:create]
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
      if @member_invitation.nil?
        render json: {
          status: 422,
          message: 'This invitation already exists'
        }
      end
      @content.notifications.create(user_id: @user.id, status: "invitation",  applicant: current_user.id, request_id: @member_invitation.id)
      render json: {
        status: 200,
        message: 'this invitation has successfully sent'
      }
    elsif !params[:email].nil?
      render json: {
        status: 422,
        message: 'The requested user doesn\'t exist'
      }
    else
      if !@content.nil?
        if @content.private_status
          current_user.member_requests.create(user_id: @content.id, target: @target.capitalize, status: "requested")
        end
        invitation = @content.member_requests.create(user_id: current_user.id, target: @target.capitalize, status: @content.private_status ? "pending" : "accepted")
        if invitation.id == nil
          render json: {
            status: 422,
            message: 'this invitation already exist'
          }
        else
          if @content.private_status
            @content.notifications.create(user_id: @content.user_id, status: "pending", applicant: current_user.id, request_id: invitation.id)
          else
            @content.notifications.create(user_id: current_user.id, status: "accepted")
          end
          render json: {
            status: 200,
            invitation: invitation,
            message: 'this invitation has successfully sent'
          }
        end
      else
        render json: {
          status: 422,
          message: 'your request is invalide, group or event not found'
        }
      end
    end
  end

  def destroy
    if !@request.nil?
      user_request = current_user.try(:member_requests).find_by_user_id(@request.try(:requests_id))
      notification = Notification.find_by_request_id(@request.try(:id))
      if !notification.nil? && !user_request.nil?
        print "---"
        if user_request.destroy && @request.destroy && notification.destroy
          render json: {
            status: 200,
            message: 'Request was successfully canceled'
          }
        else
          render json: {
            status: 422,
            message: 'Canno\'t cancel request'
          }
        end
      else
        render json: {
          status: 422,
          message: 'Canno\'t find user request'
        }
      end
    else
      render json: {
        status: 422,
        message: 'Canno\'t find this request'
      }
    end
  end

  def accept
    if @request.update(:status => "accepted")
      request = MemberRequest.find_by_user_id_and_requests_id(@request.try(:requests_id),@request.try(:user_id))
      if !request.nil?
        notification = Notification.find_by_request_id(@request.id)
        if request.destroy
          if !notification.nil?
            notification.update(:status => "accepted", :read => true)
          end
          render json: {
            status: 200,
            message: 'A new member was added'
          }
        end
      else
        render json: {
          status: 422,
          message: 'Cannot destoy member_request'
        }
      end
    else
      render json: {
        status: 422,
        message: 'Canno\'t add this member'
      }
    end
  end

  def reject
    request = MemberRequest.find_by_user_id_and_requests_id(@request.try(:requests_id), @request.try(:user_id))
    if !request.nil?
      notification = Notification.find_by_request_id(@request.id)
      if request.destroy and @request.destroy
        if !notification.nil?
          notification.update(:status => "reject", :read => true)
        end
        render json: {
          status: 200,
          message: 'This user is rejeted'
        }
      else
        render json: {
          status: 422,
          message: 'Canno\'t reject this member'
        }
      end
    else
      render json: {
        status: 422,
        message: 'member request not found'
      }
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
