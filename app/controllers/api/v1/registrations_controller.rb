class Api::V1::RegistrationsController < Api::V1::ApiController
  skip_before_action :authenticate_user_from_token!
  skip_before_action :authenticate_user!
  respond_to :json

  def create
    params.require(:firstname)
    params.require(:lastname)
    params.require(:email)
    params.require(:password)

    user = User.new(firstname: params[:firstname], lastname: params[:lastname],
                    email: params[:email], password: params[:password])

    if user.save
      render json: { user: user }
      # render :json => user.as_jsosn(:auth_token => user.authentication_token, :email => user.email), :status => 201
      # return
    else
      # warden.custom_failure!
      render :json => user.errors, :status => 422
    end
  end

  # DOCUMENTATION
  include Swagger::Blocks

  swagger_path '/api/v1/sign_up' do
    operation :post do
      key :description, 'Create an account'
      key :operationId, 'signUp'
      key :produces, [
        'application/json'
      ]
      key :tags, [
        'signup'
      ]
      parameter do
        key :name, :firstname
        key :description, "User firstname"
        key :in, :formData
        key :type, :string
        key :required, :true
      end
      parameter do
        key :name, :lastname
        key :description, "User lastname"
        key :in, :formData
        key :type, :string
        key :required, :true
      end
      parameter do
        key :name, :email
        key :description, "User email"
        key :in, :formData
        key :type, :string
        key :required, :true
      end
      parameter do
        key :name, :password
        key :description, "User password"
        key :in, :formData
        key :type, :string
        key :format, :password
        key :required, :true
      end
      response 200 do
        key :description, 'User creater'
        schema do
          key :'$ref', :User
        end
      end
      response :default do
        key :description, 'unexpected error'
        schema do
          key :'$ref', :ErrorModel
        end
      end
    end
  end
end
