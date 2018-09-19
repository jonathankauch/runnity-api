class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :event, polymorphic: true


  def group_request
    group = Group.find_by_id(self.target_id)
    if !group.nil?
      group.member_requests.where(user_id: self.applicant).last
    end
  end

  def group_invitation
    group = Group.find_by_id(self.target_id)
    if !group.nil?
      group.member_requests.where(user_id: self.user_id).last
    end
  end

  def event_request
    event = Event.find_by_id(self.target_id)
    if !event.nil?
      event.member_requests.where(user_id: self.applicant).last
    end
  end

  def event_invitation
    event = Event.find_by_id(self.target_id)
    if !event.nil?
      event.member_requests.where(user_id: self.user_id).last
    end
  end

  def group_name
    Group.find_by_id(self.target_id).try(:name)
  end

  def event_name
    Event.find_by_id(self.target_id).try(:name)
  end
end
