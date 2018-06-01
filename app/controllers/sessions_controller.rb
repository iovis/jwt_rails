class SessionsController < ApplicationController
  rescue_from ActionController::ParameterMissing, with: :render_error

  def create
    resource = User.find_for_database_authentication(email: login_params[:login])

    if resource&.valid_password?(login_params[:password])
      return render json: {
        success: true,
        auth_token: JwtService.encode(sub: resource.id)
      }
    end

    render_error
  end

  private

  def render_error
    render json: { success: false, error: 'Invalid login or password' }, status: :unauthorized
  end

  def login_params
    params.require(:user_login).permit(:login, :password)
  end
end
