class ConfigsController < ApplicationController
  before_action :find_config, only: [:update]

  def create
    config = Config.new(config_params)
    respond_to do |format|
      @success =  config.save
      format.js
    end
  end

  def update
    respond_to do |format|
      @success = @config.update_attributes(config_params)
      format.js
    end
  end

  private

  def find_config
    @config = Config.find(params[:id])
  end

  def config_params
    params.require(:config).permit(:is_invitable, :is_commentable, :group_id)
  end
end
