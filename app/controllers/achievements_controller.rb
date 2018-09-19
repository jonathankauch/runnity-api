class AchievementsController < ApplicationController
  before_action :current_user
  before_action :set_achievement, only: [:show, :edit, :update, :destroy, :success, :failure]

  def index
    @achievements_done = current_user.achievements.where('is_achieve = TRUE')
    @achievements_fail = current_user.achievements.where('is_achieve = FALSE')
    @achievements = current_user.achievements.where('due_date >= ? AND is_achieve = FALSE', Date.today)
  end

  def new
    @achievement = Achievement.new
  end

  def create
    @achievement = Achievement.new(achievement_params)
    @achievement.user = current_user
    respond_to do |format|
      if @achievement.save
        format.html { render :show, status: :created }
      else
        format.html { render json: @achievement.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @achievement.update(achievement_params)
        format.html { redirect_to @achievement, notice: 'Objectif modifié.' }
        format.json { render :show, status: :ok, location: @achievement }
      else
        format.html { render :edit }
        format.json { render json: @achievement.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
  end

  def destroy
    @achievement.destroy
    respond_to do |format|
      format.html { redirect_to achievements_url, notice: 'Objectif supprimé.' }
      format.json { head :no_content }
    end
  end


  def success
    @achievement.update(is_achieve: true)
  end

  def failure
    @achievement.update(is_achieve: false)
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