class Admin::ViewPollsController < ApplicationController

  def index

    @polls = Poll.all.paginate(:page => params[:page], :per_page => 100)

  end
  def poll_search
  	  	q = params[:q]
  	    @all_groups = Poll.all.where('polls.title LIKE ? "% #{q}%")').uniq.order(updated_at: :desc).uniq
end
end
