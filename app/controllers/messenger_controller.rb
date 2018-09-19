class MessengerController < ApplicationController
  def index
    # setup sessions for all conversations
    tmp = []
    session[:conversations] ||= []
    ids = Conversation.pluck(:id)
    session[:conversations].each do |s|
      if Conversation.exists?(s)
        tmp << s
      end
    end

    session[:conversations] = tmp

    @users = User.all.where.not(id: current_user)
    @conversations = Conversation.includes(:recipient, :messages)
                                  .find(session[:conversations])
  end
end
