class Api::V1::RankingController < Api::V1::ApiController
  respond_to :json

  before_action :authenticate_user!, :current_user

  def index
    @filter = params[:filter] || 'speed'
    if @filter == 'calorie'
      @users = User.order(total_calorie: :desc)
    elsif @filter == 'kilometer'
      @users = User.order(kilometer_done: :desc)
    else
      @users = User.order(average_speed: :desc)
    end

    render json: {
      users: @users
    }
  end
end