class User < ApplicationRecord
  acts_as_voter
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  has_friendship

  # Setting token
  before_save :ensure_authentication_token

  validates :firstname, presence: true
  validates :lastname, presence: true
  validates :email, :presence => true, :uniqueness => {:message => "Email already exists"}

  has_many :runs, :dependent => :destroy
  has_many :posts, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  has_many :groups, :dependent => :destroy
  has_many :events, :dependent => :destroy
  has_many :member_requests, as: :requests
  has_many :messages, :dependent => :destroy
  has_many :conversations, foreign_key: :sender_id, :dependent => :destroy
  has_many :pictures
  has_many :notifications, as: :target
  has_many :notifications
  has_many :achievements

  has_attached_file :avatar, styles: { medium: "300x300>" }, default_url: "https://runit-storage.s3.amazonaws.com/users/avatars/default-avatar.png"
  validates_attachment_content_type :avatar, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]

  # Geocode addr
  geocoded_by :address               # can also be an IP address
  after_validation :geocode          # auto-fetch coordinates

  reverse_geocoded_by :latitude, :longitude
  after_validation :reverse_geocode  # auto-fetch address

  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end

  def fullname
    "#{self.firstname} #{self.lastname}"
  end

  def get_picture
    if !self.pictures.empty?
      return self.pictures.last.url
    end
    ""
  end

  def suggestion_users
    query = User.where.not(id: self.id)
    if !self.friendships.empty?
      query = query.where('id NOT IN (?)', self.friendships.map(&:friend_id))
    end
    query
  end

  def friendship_requests
    self.friendships.where(:status => "requested")
  end

  def friends
    self.friendships.where(:status => "accepted")
  end

  def belongs_groups
    @ids = MemberRequest.where(user_id: self.id, requests_type: 'Group', status: "accepted").pluck(:requests_id)
    Group.where(id: @ids)
  end

  def belongs_events
    @ids = MemberRequest.where(user_id: self.id, requests_type: 'Event', status: "accepted").pluck(:requests_id)
    Event.where(id: @ids)
  end

  def all_groups
    belongs_groups + groups
  end

  def requested_groups
    self.member_requests.where(target: 'Group').pluck(:user_id)
  end

  def requested_events
    self.member_requests.where(target: 'Event').pluck(:user_id)
  end

  def create_friend_notification(user, status)
    User.find(user).notifications.create(user_id: self.id, status: status)
  end

  def user_notifications
    self.notifications.where(event_type: "User")
  end

  def today_achievements
    self.achievements.where('due_date >= ? AND is_achieve = FALSE', Date.today)
  end

  def notifications_count
    self.groups_notifications.count + self.events_notifications.count + self.friends_notifications.count
  end


  #group notifications
  def groups_notifications
    self.notifications.where("notifications.target_type='Group' AND (notifications.status='pending' OR notifications.status= 'invitation')")
  end

  #events notifications
  def events_notifications
    self.notifications.where(target_type: "Event", status: "pending")
  end

  #friends_notifications
  def friends_notifications
    self.friendships.where("friendships.status=1 AND friendships.friendable_id= ? ",self.id)
  end

  private
  def generate_authentication_token
    loop do
      token = Devise.friendly_token(40)
      break token unless User.where(authentication_token: token).first
    end
  end

  # DOCUMENTATION
  include Swagger::Blocks

  swagger_schema :User do
    key :required, [:id, :user_id]
    property :id do
      key :type, :integer
      key :format, :int64
    end
    property :email do
      key :type, :string
    end
    property :firstname do
      key :type, :string
    end
    property :lastname do
      key :type, :string
    end
    property :address do
      key :type, :string
    end
    property :phone do
      key :type, :string
    end
    property :enable do
      key :type, :boolean
    end
  end

  swagger_schema :UserInput do
    allOf do
      schema do
        key :'$ref', :User
      end
      schema do
        property :id do
          key :type, :integer
          key :format, :int64
        end
      end
    end
  end

  def change_status(friend_id, status)
    friend = Friend.find(friend_id)
    case status
      when 1
        friend.switch_to_favourite_list
      when 2
        friend.switch_to_black_list
      else
        friend.switch_to_normal_list
    end
  end

end
