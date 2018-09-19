class MemberRequest < ApplicationRecord
  validates :user_id, uniqueness: { :scope => [:requests_type, :requests_id]}
end
