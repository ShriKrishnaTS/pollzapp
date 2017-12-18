class HomeController < ApplicationController
  def index
    render json: {message: 'API Up'}
  end
end