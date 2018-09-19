require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

require_relative '../app/middleware/catch_json_parse_errors.rb'

module Runit
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Use delayed_job as job queue
    # config.active_job.queue_adapter = :delayed_job

    # Generate js file instead of coffee
    config.generators.javascript_engine = :js

    # config.to_prepare do
    #   DeviseController.respond_to :html, :json
    # end

    # Embed auth token
    # config.action_view.embed_authenticity_token_in_remote_forms = true

    config.action_dispatch.default_headers = {
        'Access-Control-Allow-Origin' => 'https://runitdocs.herokuapp.com',
        'Access-Control-Request-Method' => %w{GET POST OPTIONS}.join(","),
        'Access-Control-Allow-Headers:' => %w{Content-Type api_key Authorization}.join(",")
    }

    config.paperclip_defaults = {
      storage: :s3,
      s3_region: 'us-west-2',
      s3_host_name: "s3-us-west-2.amazonaws.com",
      s3_protocol: :https,
      s3_credentials: {
        bucket: ENV["S3_BUCKET"],
        access_key_id: ENV["AWS_ACCESS_KEY_ID"],
        secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"]
      }
    }

    # Middleware for bad json format
    config.middleware.use CatchJsonParseErrors

  end
end
