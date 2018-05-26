class PublicController < ApplicationController
  def index
    render json: { data: 'OK' }
  end
end
