class Api::V1::ConversationsController < Api::V1::ApiController
  def index
    # list all conversation
    conv = Conversation.includes(:recipient, :messages)

    #puts params[:recipient_id]

    if !params[:recipient_id].blank?
      @conversations = conv.where(sender_id: current_user.id)
                           .where(recipient_id: params[:recipient_id])

      if @conversations.size == 0
        @conversations = conv.where(sender_id: params[:recipient_id])
                             .where(recipient_id: current_user.id)
      end
    else
      @conversations = conv.where(sender_id: current_user.id)
                           .or(conv.where(recipient_id: current_user.id))
    end

    @conversations = @conversations.first

    if !@conversations.nil?
      render json: {
        conversations: {
          id: @conversations.id,
          recipient_id: @conversations.recipient_id,
          recipient_firstname: @conversations.recipient.firstname,
          recipient_lastname: @conversations.recipient.lastname,
          recipient_email: @conversations.recipient.email,
          sender_id: @conversations.sender_id,
          sender_firstname: @conversations.sender.firstname,
          sender_lastname: @conversations.sender.lastname,
          sender_email: @conversations.sender.email,
          created_at: @conversations.created_at,
          updated_at: @conversations.updated_at
        }
      }, status: :ok
    else
      render json: {}
    end

    #render "conversations/index"
  end

  def create
    if !params[:recipient_id].blank?
      puts params.inspect
      conv = Conversation.includes(:recipient, :messages)

      @conversations = conv.where(sender_id: current_user.id)
                           .where(recipient_id: params[:recipient_id])
      puts @conversations.inspect

      if @conversations.size == 0
        @conversations = conv.where(sender_id: params[:recipient_id])
                             .where(recipient_id: current_user.id)
        puts @conversations.inspect
      end

      puts @conversations.inspect
      puts @conversations.nil?
      puts "dddd"
      puts @conversations.size
      if @conversations.size != 0
        render json: { conversation: @conversations.first }, status: :ok and return
        #render "conversations/index" and return
      end
    end

    @exist = current_user.conversations.find_by(recipient_id: params[:recipient_id])

    if !@exist.nil?
      render json: { conversation: @exist }, status: :ok and return
    end

    @conversation = current_user.conversations.new(recipient_id: params[:recipient_id])

    if @conversation.save
      render json: { conversation: @conversation }, status: :ok
    else
      render json: { error: @conversation.errors.messages }, status: 422
    end
  end
end
