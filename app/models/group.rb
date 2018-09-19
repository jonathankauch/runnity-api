class Group < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :notifications, as: :target, dependent: :destroy
  has_many :member_requests, as: :requests, dependent: :destroy
  has_many :pictures, dependent: :destroy
  has_one :config
  belongs_to :user
  accepts_nested_attributes_for :config
  validates :name, presence: true
  acts_as_votable

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
    self.member_requests.where(user_id: user.id, status: "accepted").pluck(:id).empty?
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

  swagger_schema :Group do
    key :required, [:id, :user_id]
    property :id do
      key :type, :integer
      key :format, :int64
    end
    property :name do
      key :type, :string
    end
    property :private do
      key :type, :boolean
    end
  end

  swagger_schema :GroupInput do
    allOf do
      schema do
        key :'$ref', :Group
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
