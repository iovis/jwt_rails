class SessionsController < ApplicationController
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
    token = JwtToken.find_from(request)

    if token.user.active?
      render_token token.user
    else
      render_error 'User inactive'
    end
  rescue ::JWT::DecodeError
    render_error 'Invalid token'
  end

  private

  def render_token(resource)
    token = JwtToken.generate_for(resource).token
    render json: { success: true, auth_token: token }
  end

  def render_error(message)
    render json: { success: false, error: message }, status: :unauthorized
  end

  def login_params
    params.require(:user_login).permit(:login, :password)
  end
end
