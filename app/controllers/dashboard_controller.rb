class DashboardController < ApplicationController
  before_action :authenticate_admin!

  def index
    @page='dashboard'
    render :layout => "layouts/dashboard"
  end
end
