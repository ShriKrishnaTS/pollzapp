class ListPollsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @allPolls=Poll.where deleted: false
    render :layout => "layouts/dashboard"
  end

  def update
    poll=Poll.find params[:id]
    if params[:media_disabled].present?
      poll.media_disabled=params[:media_disabled]
      poll.save
    end
    if params[:deleted].present?
      poll.deleted=params[:deleted]
      poll.save
    end
    redirect_to :back
  end

  def media_disabled
    @allPolls = Poll.where media_disabled: true, deleted: false
    render :layout => "layouts/dashboard"

  end

  def deleted
    @allPolls = Poll.all
    render :layout => "layouts/dashboard"

  end

  def destroy
    @poll=Poll.find params[:id]
    @poll.deleted=true
    @poll.save

    redirect_to :back
  end

  def restore
    @poll=Poll.find params[:id]
    @poll.deleted=false
    @poll.save

    redirect_to :back
  end
end
