class PrivateController < ApplicationController
  before_action :authenticate_user!

  def index
    render json: { data: 'OK' }
  end
end
