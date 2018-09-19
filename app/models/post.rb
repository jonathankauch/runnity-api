class Post < ApplicationRecord
  has_many :pictures, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :content, presence: true
  belongs_to :user
  belongs_to :event
  belongs_to :group

  acts_as_votable

  def change_post_private_status
    self.private = !self.private
  end

  # DOCUMENTATION
  include Swagger::Blocks

  swagger_schema :Post do
    key :required, [:id, :user_id]
    property :id do
      key :type, :integer
      key :format, :int64
    end
    property :content do
      key :type, :string
    end
    property :picture do
      key :type, :string
    end
    property :user_id do
      key :type, :integer
      key :format, :int64
    end
    property :event_id do
      key :type, :integer
      key :format, :int64
    end
    property :group_id do
      key :type, :string
    end
    property :like do
      key :type, :integer
      key :format, :int64
    end
  end

  swagger_schema :PostInput do
    allOf do
      schema do
        key :'$ref', :Post
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
