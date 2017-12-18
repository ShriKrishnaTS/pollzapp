class Admin::ViewGroupsController < ApplicationController

	def destroy
		@group = Group.find(params[:id])
		@group.destroy
		respond_to do |format|
  		redirect_to admin_view_groups_path, notice: 'Group was successfully deleted'
	    format.json { head :no_content }
   
	end
	
end

	def update
    if @group.update(group_params)
      group_user = @current_user.user_groups.find_by_group_id(@group.id)
      @user_type = group_user ? group_user.user_type : nil
      render :show
    else
      render json: @group.errors, status: :unprocessable_entity
    end
  end
  	def show
  	end

end 
