class Comment < ApplicationRecord
  has_many :pictures, dependent: :destroy

  belongs_to :user
  belongs_to :post

  validates :content, presence: true

  # DOCUMENTATION
  include Swagger::Blocks

  swagger_schema :Comment do
    key :required, [:id, :user_id]
    property :id do
      key :type, :integer
      key :format, :int64
    end
    property :content do
      key :type, :string
    end
    property :picutre do
      key :type, :string
    end
    property :user_id do
      key :type, :integer
      key :format, :int64
    end
    property :post_id do
      key :type, :integer
      key :format, :int64
    end
  end

  swagger_schema :CommentInput do
    allOf do
      schema do
        key :'$ref', :Comment
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
