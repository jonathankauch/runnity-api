Aws.config.update({
  credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY'])
  # :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
  # :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
})

s3 = Aws::S3::Client.new(region: 'us-west-2')
Aws::VERSION = Gem.loaded_specs["aws-sdk"].version

# begin
#   # do stuff
# rescue Aws::S3::Errors::ServiceError
#   # rescues all errors returned by Amazon Simple Storage Service
# end
