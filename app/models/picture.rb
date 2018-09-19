class Picture < ApplicationRecord
  belongs_to :user
  belongs_to :group
  belongs_to :event
  belongs_to :post

  # DOCUMENTATION
  include Swagger::Blocks

  swagger_schema :Picture do
    key :required, [:id, :user_id, :name, :url]
    property :id do
      key :type, :integer
      key :format, :int64
    end
    property :user_id do
      key :type, :integer
      key :format, :int64
    end
    property :name do
      key :type, :string
    end
    property :url do
      key :type, :string
    end
  end
end
