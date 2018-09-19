class Api::V1::RunsController < Api::V1::ApiController
  respond_to :json

  before_action :authenticate_user!, :current_user
  before_action :set_run, only: [:show, :destroy, :define_as_a_spot]

  # GET /runs
  # GET /runs.json
  def index
    @runs = current_user.runs.as_json
    @runs.each do |obj|
      begin
        coord = JSON.parse(obj['coordinates'])
        obj['real_coordinates'] = coord
      rescue JSON::ParserError => e
        logger.error("Could not parse, coordinates for run #{obj['id']}")
      end
    end
    render :json => { runs: @runs, status: :ok }
  end

  # GET /runs/1
  # GET /runs/1.json
  def show
  end

  # GET /runs/new
  def new
    @run = Run.new
  end

  # POST /runs
  # POST /runs.json
  def create
    if params != nil
      @run = current_user.runs.new(run_params(params))

      if @run != nil
        begin
          coord = JSON.parse(params[:coordinates])
          coord.each do |obj|
            if !obj.has_key?('latitude') || !obj.has_key?('longitude')
              raise ArgumentError.new('Coordinate object is missing latitude or longitude')
            end
            if obj['latitude'].blank? || obj['longitude'].blank?
              raise ArgumentError.new('Latitude or longitude is not a valid value')
            end
          end
        rescue JSON::ParserError => e
          render :json => {message: 'Not JSON parsable coordinates passed'}, :status => 422 and return
        rescue ArgumentError => e
          render :json => {message: 'Not JSON parsable coordinates passed',
                           error: "#{e}" }, :status => 422 and return
        end

        average_speed = ((@run.total_distance / 1000.0) / (@run.total_time / 60.0)).round(2)
        speed_m_by_min = average_speed * 1000.0 / 60.0
        cost_tab = costs
        if speed_m_by_min <= 100
          cost = cost_tab[:'100']
        elsif speed_m_by_min >= 400
          cost = cost_tab[:'400']
        else
          cost = cost_tab[speed_m_by_min.to_s.to_sym] || 1.026
        end
        calories = ((cost * current_user.weight) * (@run.total_distance / 1000.0)).round(2)

        # puts calories
        # For calories count
        # http://entrainement-sportif.fr/calories.htm

        @run.calories = calories
        begin
          @run.save!
        rescue ActiveRecord::RecordInvalid => e
          render :json => {message: "#{e.message}"}, :status => 422
        end

        render json: @run, status: 200
      else
        render :json => @run.errors, :status => 422
      end
    end
  end

  # DELETE /runs/1
  # DELETE /runs/1.json
  def destroy
    @run.destroy
    respond_to do |format|
      format.html { redirect_to runs_url, notice: 'Run was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def costs
    cost_tab = {
      '100': 1.060, '110': 1.052, '120': 1.046, '130': 1.041,
      '140': 1.037, '150': 1.034, '160': 1.031, '170': 1.029,
      '180': 1.028, '190': 1.027, '200': 1.027, '210': 1.026,
      '220': 1.027, '230': 1.027, '240': 1.028, '250': 1.029,
      '260': 1.031, '270': 1.032, '280': 1.034, '290': 1.036,
      '300': 1.038, '310': 1.040, '320': 1.043, '330': 1.046,
      '340': 1.049, '350': 1.052, '360': 1.055, '370': 1.058,
      '380': 1.062, '390': 1.065, '400': 1.068
    }
  end

  def define_as_a_spot
    if @run.update(is_spot: !@run.is_spot)
      render json: @run, status: 200
    else
      render :json => @run.errors, :status => 422
    end
  end

  def get_spots
    @runs = Run.where(is_spot: true)
    render json: format_runs(@runs), status: 200
  end

  def like
    @run = Run.find(params[:id])
    @run.liked_by current_user
    render json: @run, status: 200
  end

  def unlike
    @run = Run.find(params[:id])
    @run.unliked_by current_user
    render json: @run, status: 200
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_run
      @run = Run.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def run_params(parameters)
      data = {}
      data[:coordinates] = parameters[:coordinates]
      data[:started_at] = parameters[:started_at] || Date.today
      data[:max_speed] = parameters[:max_speed] || 10
      data[:total_distance] = parameters[:total_distance] || 15
      data[:total_time] = parameters[:total_time] || 30
      data[:is_spot] = parameters[:is_spot] || false
      data
    end

    def format_runs(runs)
      toto = []
      runs.each do |run|
        coord = nil
        begin
          coord = JSON.parse(run.coordinates)
        rescue JSON::ParserError => e
          logger.error("Could not parse, coordinates for run #{run['id']}")
        end

        toto << {
          id: run.id,
          real_coordinates: coord,
          created_at: run.created_at,
          updated_at: run.updated_at,
          started_at: run.started_at,
          total_distance: run.total_distance,
          total_time: run.total_time,
          max_speed: run.max_speed,
          user_id: run.user_id,
          likes: run.votes_for.size,
          calories: run.calories,
          is_spot: run.is_spot,
        }
      end

      { runs: toto }
    end

  # DOCUMENTATION
  include Swagger::Blocks

  swagger_path '/api/v1/runs' do
    operation :post do
      key :description, 'Create a run'
      key :operationId, 'addRun'
      key :produces, [
        'application/json'
      ]
      key :tags, [
        'run'
      ]
      parameter do
        key :name, :id
        key :coordinates, :text
        key :started_at, :dateTime
        key :max_speed, :integer
        key :total_distance, :integer
        key :total_time, :integer
        schema do
          key :'$ref', :RunInput
        end
      end
      response 200 do
        key :description, 'Run created'
        schema do
          key :'$ref', :Run
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
  swagger_path '/api/v1/runs' do
    operation :get do
      key :description, 'Get all runs'
      key :operationId, 'listRun'
      key :produces, [
        'application/json'
      ]
      key :tags, [
        'run'
      ]
      response 200 do
        key :description, 'Run list'
        schema do
          key :'$ref', :Run
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
