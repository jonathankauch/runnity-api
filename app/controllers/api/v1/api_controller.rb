class Api::V1::ApiController < ApplicationController
  respond_to :json
  skip_before_action :verify_authenticity_token, if: :json_request?, raise: false

  # This is our new function that comes before Devise's one
  # Ensure user_email, and user_token is send
  before_action :authenticate_user_from_token!

  # This is Devise's authentication
  # Ensure current_user exist
  before_action :authenticate_user!

  around_action :set_user_context
  before_action :set_raven_context

  rescue_from ActionController::ParameterMissing do |e|
    render json: { error: e.message }, status: :bad_request
  end

  # rescue_from ActionController::UnpermittedParameters do |e|
  #   render json: { error:  e.message }, status: :bad_request
  # end

  private

  def authenticate_user_from_token!
    user_email = params[:user_email].presence || request.headers["X-User-Email"]
    user       = user_email && User.find_by_email(user_email)
    token      = params[:user_token] || request.headers["X-User-Token"]

    # Notice how we use Devise.secure_compare to compare the token
    # in the database with the token given in the params, mitigating
    # timing attacks.
    if user && Devise.secure_compare(user.authentication_token, token)
      # Notice we are passing store false, so the user is not
      # actually stored in the session and a token is needed
      # for every request. If you want the token to work as a
      # sign in token, you can simply remove store: false.
      sign_in user, store: false
    else
      render json: { message: 'Bad credentials, missing token or email' },
             status: :unauthorized
    end
  end

  def set_user_context(&block)
    if !current_user.nil?
      # Ensure the attributes are mapped properly here
      user_context = Timber::Contexts::User.new(id: current_user.id,
                                                email: current_user.email,
                                                name: current_user.fullname)
      Timber.with_context(user_context, &block)
    else
      block.call
    end
  end

  def set_raven_context
    Raven.user_context(id: session[:current_user_id])
    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end

  protected

  def json_request?
    request.format.json?
  end
end
