class Api::V1::UploadPicsController < Api::V1::ApiController
  before_action :current_user
  before_action :authenticate_user!, :current_user

  def create
    params.require(:picture)

    bucket = ENV['S3_BUCKET']
    pic = params[:picture]
    content_type = pic.content_type.split('/').last

    if content_type == 'jpeg'
      content_type = 'jpg'
    end

    s3 = Aws::S3::Client.new(region: 'us-west-2')
    md5 = Digest::MD5.file(params[:picture].tempfile).hexdigest
    filename = md5 + '.' + content_type
    s3.put_object(bucket: bucket, key: 'pictures/' + filename, body: pic,
                  acl: 'public-read', content_type: pic.content_type)
    link = 'https://s3-us-west-2.amazonaws.com/' + bucket + '/pictures/' + filename

    @picture = current_user.pictures.new(name: filename, url: link)

    if @picture.save
      render json: { picture: @picture }
    else
      render json: { picture: @picture.errors, status: 422 }
    end
  end

  def index
    @pics = Picture.where(user_id: @current_user.id)
    render json: { pictures: @pics }
  end

  def show
    @picture = current_user.pictures.find_by_id(params[:id])
    if @picture.nil?
      render json: { error: "Picture not found", status: 404 }
    end
    render json: { picture: @picture }
  end

  def destroy
    @picture = current_user.pictures.find_by_id(params[:id])
    if @picture.nil?
      render json: { error: "Picture not found", status: 404 }
    end

    bucket = ENV['S3_BUCKET']
    s3 = Aws::S3::Client.new(region: 'us-west-2')
    s3.delete_object(bucket: bucket, key: 'pictures/' + @picture.name)

    @picture.destroy
    render json: { message: "Picture successfully removed" }
  end

   # DOCUMENTATION
  include Swagger::Blocks

  swagger_path '/api/v1/users/{user_id}/picture' do
    operation :get do
      key :description, 'Get all picture'
      key :operationId, 'getAllPicture'
      key :produces, [
        'application/json'
      ]
      key :tags, [
        'picture',
        'upload'
      ]
      parameter do
        key :name, :user_id
        key :in, :path
        key :description, "user's id"
        key :required, :true
        key :type, :integer
      end
      response 200 do
        key :description, 'Picture uploaded'
        schema do
          key :'$ref', :Picture
        end
      end
      response :default do
        key :description, 'unexpected error'
        schema do
          key :'$ref', :ErrorModel
        end
      end
      security api_key: []
    end
  end

  swagger_path '/api/v1/users/{user_id}/upload_pics/{id}' do
    operation :get do
      key :description, 'Get a picture'
      key :operationId, 'getPictureById'
      key :produces, [
        'application/json'
      ]
      key :tags, [
        'picture',
        'upload'
      ]
      parameter do
        key :name, :user_id
        key :in, :path
        key :description, "user's id who the picture belongs to"
        key :required, :true
        key :type, :integer
      end
      parameter do
        key :name, :id
        key :in, :path
        key :description, "id of the picture"
        key :required, :true
        key :type, :integer
      end
      response 200 do
        key :description, 'Picture uploaded'
        schema do
          key :'$ref', :Picture
        end
      end
      response :default do
        key :description, 'unexpected error'
        schema do
          key :'$ref', :ErrorModel
        end
      end
      security api_key: []
    end
  end

  swagger_path '/api/v1/users/{user_id}/upload_pics' do
    operation :post do
      key :description, 'Post a picture'
      key :operationId, 'uploadPicture'
      key :produces, [
        'application/json'
      ]
      key :tags, [
        'picture',
        'upload'
      ]
      parameter do
        key :name, :user_id
        key :in, :path
        key :description, "user's id"
        key :required, :true
        key :type, :integer
      end
      parameter do
        key :name, :picture
        key :in, :formData
        key :description, "picture to be upload"
      end
      response 200 do
        key :description, 'Picture uploaded'
        schema do
          key :'$ref', :Picture
        end
      end
      response :default do
        key :description, 'unexpected error'
        schema do
          key :'$ref', :ErrorModel
        end
      end
      security api_key: []
    end
  end

  swagger_path '/api/v1/users/{user_id}/upload_pics/{id}' do
    operation :delete do
      key :description, 'Delete a picture'
      key :operationId, 'deletePicture'
      key :produces, [
        'application/json'
      ]
      key :tags, [
        'picture',
        'upload'
      ]
      parameter do
        key :name, :user_id
        key :in, :path
        key :description, "user's id"
        key :required, :true
        key :type, :integer
      end
      parameter do
        key :name, :id
        key :in, :path
        key :description, "id of the picture to be delete"
        key :required, :true
        key :type, :integer
      end
      response 200 do
        key :description, 'Picture uploaded'
        schema do
          key :'$ref', :Picture
        end
      end
      response :default do
        key :description, 'unexpected error'
        schema do
          key :'$ref', :ErrorModel
        end
      end
      security api_key: []
    end
  end
end
