class ApidocsController < ActionController::Base
  include Swagger::Blocks

  swagger_root do
    key :swagger, '2.0'
    info do
      key :version, '1.0.0'
      key :title, 'Runit documentation'
      key :description, 'A sample API that uses a petstore as an example to ' \
                        'demonstrate features in the swagger-2.0 specification'
      key :termsOfService, 'http://helloreverb.com/terms/'
      contact do
        key :name, 'Runit API Team'
      end
      license do
        key :name, 'MIT'
      end
    end
    key :basePath, '/api'
    key :consumes, ['application/json']
    key :produces, ['application/json']
    security_definition :api_key do
      key :token, "X-User-Token"
      key :email, "X-User-Email"
      key :in, :header
    end
  end

  # A list of all classes that have swagger_* declarations.
  SWAGGERED_CLASSES = [
    Api::V1::RegistrationsController,
    Api::V1::RunsController,
    Run,
    Api::V1::UsersController,
    User,
    Api::V1::UploadPicsController,
    Picture,
    Api::V1::PostsController,
    Post,
    Api::V1::CommentsController,
    Comment,
    Api::V1::GroupsController,
    Group,
    Api::V1::EventsController,
    Event,
    ErrorModel,
    self,
  ].freeze

  def index
    render json: Swagger::Blocks.build_root_json(SWAGGERED_CLASSES)
  end
end
