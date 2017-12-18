class Admin::ViewPollsController < ApplicationController

  def index
    @polls = Poll.all.paginate(:page => params[:page], :per_page => 10)

  end
end
