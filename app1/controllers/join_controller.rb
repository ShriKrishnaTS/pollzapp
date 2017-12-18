class JoinController < ApplicationController

  def create
    @join = @current_user.joins.build(:group_id => params[:group_id])
    if @join.save
      flash[:notice] = "You have joined this group."
      redirect_to :back
    else
      flash[:error] = "Unable to join."
      redirect_to :back
    end
  end

  def destroy
       @join = current_user.joins.find(params[:id])
    @join.destroy
    flash[:notice] = "Removed membership."
        redirect_to :back
  end
end