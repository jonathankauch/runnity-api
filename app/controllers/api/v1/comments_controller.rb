class Api::V1::CommentsController < Api::V1::ApiController
  respond_to :json

  before_action :authenticate_user!, :current_user
  before_action :set_comment, only: [:show, :edit, :update, :destroy]

  # GET /comments
  # GET /comments.json
  def index
    @comments = Comment.all
    render :json => { comments: @comments, status: :ok }
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
  end

  # GET /comments/new
  def new
    @comment = Comment.new
  end

  # GET /comments/1/edit
  def edit
  end

  # comment /comments
  # comment /comments.json
  def create
    if @comment = current_user.comments.new(comment_params)
      render json: @comment, status: 200 if @comment.save
    else
      render :json => @comment.errors, :status => 422
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    if @comment.update(comment_params)
      render json: @comment, status: 200
    else
      render :json => @comment.errors, :status => 422
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    if @comment.user == current_user
      if @comment.destroy
        render json: {
          status: 200,
          message: 'Comment deleted'
        }
      else
        render :json => @comment.errors, :status => 422
      end
    else
      render :json => {msg: 'error'}, :status => 422
    end
end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:post_id, :content, :picture, :user_id)
    end

  # DOCUMENTATION
  include Swagger::Blocks

  swagger_path '/api/v1/comments' do
    operation :post do
      key :description, 'Create a comment'
      key :operationId, 'addComment'
      key :produces, [
        'application/json'
      ]
      key :tags, [
        'comment'
      ]
      parameter do
        key :name, :id
        key :content, :string
        key :picture, :string
        key :user_id, :integer
        key :post_id, :integer
        schema do
          key :'$ref', :PostInput
        end
      end
      response 200 do
        key :description, 'Comment created'
        schema do
          key :'$ref', :Comment
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
  swagger_path 'api/v1/comments/{id}' do
    operation :get do
      key :description, 'Get comment information'
      key :operationId, 'getComment'
      key :tags, [
          'comment'
      ]
      parameter do
        key :name, :id
        key :in, :path
        key :description, 'Id of post to fetch'
        key :required, true
        key :type, :integer
        key :format, :int64
      end
      response 200 do
        key :description, 'Comment response'
        schema do
          key :'$ref', :Comment
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
  swagger_path 'api/v1/comments/{id}' do
    operation :put do
      key :description, 'Upload comment'
      key :operationId, 'uploadComment'
      key :tags, [
        'comment'
      ]
      key :produces, [
        'application/json'
      ]
      parameter do
        key :name, :id
        key :in, :path
        key :description, 'Id of comment to fetch'
        key :required, true
        key :type, :integer
        key :format, :int64
      end
      parameter do
        key :content, :string
        key :picture, :string
        key :user_id, :integer
        key :post_id, :integer
      end
      response 200 do
        key :description, 'Comment response'
        schema do
          key :'$ref', :Comment
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
  swagger_path 'api/v1/comments/{id}' do
    operation :delete do
      key :description, 'Delete comment'
      key :operationId, 'deleteComment'
      key :tags, [
          'comment'
      ]
      parameter do
        key :name, :id
        key :in, :path
        key :description, 'Id of comment to fetch'
        key :required, true
        key :type, :integer
        key :format, :int64
      end
      response 200 do
        key :description, 'Comment response'
        schema do
          key :'$ref', :Comment
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