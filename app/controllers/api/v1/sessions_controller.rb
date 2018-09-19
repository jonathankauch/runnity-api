class Api::V1::SessionsController < Devise::SessionsController
  skip_before_action :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }
  #skip_before_action :verify_authenticity_token, if: :json_request?
  before_action :ensure_params_exist
  # skip_before_action :authenticate_user_from_token!
  skip_before_action :verify_authenticity_token, if: :json_request?
  respond_to :json

  def create
    self.resource = User.find_for_database_authentication(email: params[:email])
    return invalid_login_attempt unless resource

    if resource.valid_password?(params[:password])
      puts resource_name
      sign_in(:user, resource, store: false)
      #current_user.update authentication_token: nil
      render :json => { :user => current_user,
                        :auth_token => current_user.authentication_token,
                        :success => true,
                        :status => :ok }
      return
    end
    invalid_login_attempt
  end

  def destroy
    sign_out(resource_name)
    if current_user
      current_user.update authentication_token: nil
      signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
      render :json => { :message => "Logged out" }.to_json, :status => :ok
    else
      render :json => {}.to_json, :status => :unprocessable_entity
    end
  end

  protected

  def ensure_params_exist
    puts params.inspect
    return unless params[:email].blank?
    render :json => { :success => false, :message => "missing email parameter" }, :status => 422
  end

  def invalid_login_attempt
    warden.custom_failure!
    render :json => { :success => false, :message=> "Error with your login or password" }, :status => 401
  end


  private

  def json_request?
    request.format.json?
  end
end
