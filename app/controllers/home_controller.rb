class HomeController < ApplicationController
  # skip_before_action :authenticate_user!, only: [:index]
  before_action :current_user, only: [:my_runs]

  def index
    @posts = Post.order(created_at: 'DESC').limit(5)
    @post = Post.new
    @run = current_user.runs.last
    @events = Event.limit 5
    @groups = Group.limit 5
  end

  def advice
  end

  def my_runs
    @last_run = current_user.runs.last
    @runs = Run.where(user_id: @current_user.id).order(created_at: 'DESC')
  end

  def spots
    @runs = Run.where(is_spot: true).order(created_at: 'DESC')
    @last_run = @runs.first
  end

  def define_run_as_spot
    @run = Run.find(params[:id])
    if @run.update(is_spot: !@run.is_spot)
      redirect_to :back
    else
      redirect_to :back
    end
  end

  def like_run
    @run = Run.find(params[:id])
    @run.liked_by current_user
    redirect_to spots_path
  end

  def unlike_run
    @run = Run.find(params[:id])
    @run.unliked_by current_user
    redirect_to spots_path
  end

  def landing
    if current_user
      print 'Should redirect to index'
    end
  end

  def find_partner
  end

  def fetch_partner
    args = partner_params

    if args[:level].to_i == 0
      users = User.where("id != ?", current_user.id)
                  .near(args[:city], args[:range].to_i, unit: :km)
    elsif args[:level].to_i <= 12
      users = User.where("average_speed < ? AND id != ?", args[:level], current_user.id)
                  .near(args[:city], args[:range].to_i, unit: :km)
    else
      users = User.where("average_speed > ? AND id != ?", args[:level], current_user.id)
                  .near(args[:city], args[:range].to_i, unit: :km)
    end

    geo_tab = []
    geo_tab << Geocoder.coordinates(args[:city])

    avatars = users.map {|x| x.avatar.url }
    u = users.as_json
    u.each_with_index do |x, index|
      x[:avatar] = avatars[index]
      puts [x['latitude'].to_f, x['longitude'].to_f]
      geo_tab << [x['latitude'].to_f, x['longitude'].to_f] if !x['latitude'].nil?
    end

    puts geo_tab.inspect
    puts geo_tab

    center = Geocoder::Calculations.geographic_center(geo_tab)

    render json: {
      users: u,
      center: center,
      zoom: 12.5 - (args[:range].to_f / 10.0)
    }
  end

  def ranking
    @filter = params[:filter] || 'speed'
    if @filter == 'calorie'
      @users = User.order(total_calorie: :desc)
    elsif @filter == 'kilometer'
      @users = User.order(kilometer_done: :desc)
    else
      @users = User.order(average_speed: :desc)
    end

    @users
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def partner_params
    params.require(:partner).permit(:city, :range, :level)
  end
end
