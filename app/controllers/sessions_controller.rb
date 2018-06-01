class SessionsController < ApplicationController
  before_action :parse_token, only: :refresh_token

  def create
    resource = User.find_for_database_authentication(email: login_params[:login])

    if resource&.valid_password?(login_params[:password])
      return render_token resource.id
    end

    render_error 'Invalid login or password'
  rescue ActionController::ParameterMissing
    render_error 'Invalid login or password'
  end

  def refresh_token
    resource = User.find(@payload.sub)

    if resource_active?(resource)
      render_token @payload.sub
    else
      render_error 'User inactive'
    end
  end

  private

  def render_token(resource_id)
    token = JwtService.encode(sub: resource_id, exp: 10.seconds.from_now)
    render json: { success: true, auth_token: token }
  end

  def render_error(message)
    render json: { success: false, error: message }, status: :unauthorized
  end

  def login_params
    params.require(:user_login).permit(:login, :password)
  end

  def parse_token
    token = AuthorizationHeadersService.extract_token_from(request)
    @payload = OpenStruct.new(**JwtService.decode(token).to_options)
  rescue ::JWT::ExpiredSignature
    @payload = OpenStruct.new(**JwtService.unsafe_decode(token).to_options)
  rescue ::JWT::DecodeError
    render_error 'Invalid token'
  end

  USER_INACTIVITY_WINDOW = 20.seconds

  def resource_active?(resource)
    resource.current_sign_in_at > USER_INACTIVITY_WINDOW.ago
  end
end
