class Event < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :pictures, dependent: :destroy
  has_many :notifications, as: :target, dependent: :destroy
  has_many :member_requests, as: :requests, dependent: :destroy
  belongs_to :user

  acts_as_votable
  validates :name, presence: true
  validates :private_status, inclusion: { in: [ true, false ] }

  has_attached_file :avatar, styles: { medium: "300x300>" }, default_url: "group_default.jpg"
  validates_attachment_content_type :avatar, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]

  def members
    self.member_requests.where(status: "accepted")
  end

  def pending_requests
    self.member_requests.where(status: "pending")
  end

  def find_member_request(user)
    self.member_requests.where(user_id: user).pluck(:id)
  end

  def is_member(user)
    self.member_requests.where(user_id: user.try(:id), status: "accepted").pluck(:id).empty?
  end

  def get_picture
    if self.avatar.nil?
      "group-profil-default.jpg"
    else
      self.avatar.url
    end
  end

  # DOCUMENTATION
  include Swagger::Blocks

  swagger_schema :Event do
    key :required, [:id, :user_id]
    property :id do
      key :type, :integer
      key :format, :int64
    end
    property :name do
      key :type, :string
    end
    property :description do
      key :type, :strong
    end
    property :start_date do
      key :type, :dateTime
    end
    property :end_date do
      key :type, :dateTime
    end
    property :city do
      key :type, :string
    end
    property :private_status do
      key :type, :boolean
    end
    property :distance do
      key :type, :integer
    end
    property :user_id do
      key :type, :integer
      key :format, :int64
    end
  end

  swagger_schema :EventInput do
    allOf do
      schema do
        key :'$ref', :Event
      end
      schema do
        property :id do
          key :type, :integer
          key :format, :int64
        end
      end
    end
  end
end
