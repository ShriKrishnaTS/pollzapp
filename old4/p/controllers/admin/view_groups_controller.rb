class Admin::ViewGroupsController < ApplicationController
  around_filter :catch_not_found
	
	


	  def index

    @groups = Group.all.paginate(:page => params[:page], :per_page => 10)

  end

   def destroy
    @group.destroy
    respond_to do |format|
      format.html { redirect_to groups_url, notice: 'Group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end



private

def catch_not_found
  yield
rescue ActiveRecord::RecordNotFound
  render "shares/index"
end
end
