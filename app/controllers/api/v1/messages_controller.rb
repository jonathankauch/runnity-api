class Api::V1::MessagesController < Api::V1::ApiController
  def index
    # list all conversation
    @messages = Message.where(conversation_id: params[:conversation_id]).order(created_at: :asc)

    render json: {
      messages: @messages
    }, status: :ok
  end

  def create
    @conversation = Conversation.find_by_id(params[:conversation_id])

    if @conversation.nil?
      render json: { error: 'Conversation not found' }, status: :not_found
      return
    end

    @message = @conversation.messages.new(user_id: current_user.id,
                                          body: params[:body])

    if @message.save
      render json: { message: 'Successfully sent' }, status: :ok
    else
      render json: { error: @message.error.messages }, status: 422
    end
  end
end
