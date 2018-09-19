class Api::V1::AchievementsController < Api::V1::ApiController
  respond_to :json

  before_action :authenticate_user!, :current_user
  before_action :set_achievement, only: [:show, :edit, :update, :destroy, :success, :failure]

  def index
    @achievements_done = current_user.achievements.where('is_achieve = TRUE')
    @achievements_fail = current_user.achievements.where('is_achieve = FALSE')
    @achievements = current_user.achievements.where('due_date >= ? AND is_achieve = FALSE', Date.today)
    render json: {
      achievements_done: @achievements_done,
      achievements_fail: @achievements_fail,
      achievements: @achievements,
    }
  end

  def new
    @achievement = Achievement.new
  end

  def create
    @achievement = current_user.achievements.new(achievement_params)
    if @achievement.save
      render json: {
        status: 200,
        message: 'Achievement created'
      }
    else
      render json: {
        status: 500,
        message: 'Achievement create failed'
      }
    end
  end

  def edit
  end

  def update
    if @achievement.update(achievement_params)
      render json: {
        status: 200,
        message: 'Achievement updated'
      }
    else
      render json: {
        status: 500,
        message: 'Achievement update failed'
      }
    end
  end

  def show
  end

  def destroy
    if @achievement.destroy
      render json: {
        status: 200,
        message: 'Achievement deleted'
      }
    else
      render json: {
        status: 500,
        message: 'Achievement delete failed'
      }
    end
  end

  def success
    @achievement.update(is_achieve: true)
    render json: {
      message: 'Success'
    }
  end

  def failure
    @achievement.update(is_achieve: false)
    render json: {
      message: 'Success'
    }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_achievement
      @achievement = Achievement.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def achievement_params
      params.require(:achievement).permit(:content, :start_date, :due_date, :achievement_type, :value)
    end
end