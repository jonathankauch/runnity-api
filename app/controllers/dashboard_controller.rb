class DashboardController < ApplicationController
  def index
    @runs = current_user.runs
    if !@runs.blank?
      @nb_runs = @runs.size
      @kms = 0
      @total_time_run = 0
      @calories = 0
      @runs_by_month = Array.new(12, 0)
      @distance_by_month = Array.new(12, 0)
      @time_run_by_month = Array.new(12, 0)
      @calories_by_month = Array.new(12, 0)
      @max_speed = @runs.order(max_speed: :desc).first.max_speed
      @runs.each do |r|
        @kms += r.total_distance
        @total_time_run += r.total_time
        @runs_by_month[r.created_at.month - 1] += 1
        @distance_by_month[r.created_at.month - 1] += (r.total_distance / 1000.0)
        @time_run_by_month[r.created_at.month - 1] += r.total_time
        @calories_by_month[r.created_at.month - 1] += r.calories
        @calories += r.calories
      end
      @average_speed = ((@kms / 1000.0) / (@total_time_run / 60.0)).round(2)
      @kms /= 1000
      @kms = @kms.round(0)
      @calories = @calories.round(0)
      # 1km = 1312,3359580052 steps
      @nb_steps = (@kms * 1312.3359580052).round(0)
    end
  end
end
