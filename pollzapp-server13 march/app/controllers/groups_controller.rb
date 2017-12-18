class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :update, :destroy, :polls]
  include Authenticate

  # GET /groups
  # GET /groups.json
  def index
    @groups = @current_user.user_groups.unblocked.order(user_type: :desc, created_at: :desc).active.paginate(:page => params[:page], :per_page => 25)
  end


  # GET /groups/1
  # GET /groups/1.json
  def show
     @group_user = @current_user.user_groups.find_by_group_id(@group.id)
    @user_type = @group_user ? @group_user.user_type : nil
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = Group.new(group_params)
    @group.group_users.build user_type: 'Group Owner', user_id: @current_user.id
    @group.share_id = Array.new(8){rand(36).to_s(36)}.join


    respond_to do |format|
      if @group.save
        format.html { redirect_to @group, notice: 'Group was successfully created.' }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :new }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end
  

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    if @group.update(group_params)
      group_user = @current_user.user_groups.find_by_group_id(@group.id)
      @user_type = group_user ? group_user.user_type : nil
        @group.save
      render :show

    else
      render json: @group.errors, status: :unprocessable_entity
    end
  end

   def delete_image
         @group = Group.find(params[:id])
         @group.remove_image!
         @group.save
         render :show
   end
  def revoke 
    @group = Group.find(params[:id])
       group_user = @current_user.user_groups.find_by_group_id(@group.id)
      @user_type = group_user ? group_user.user_type : nil
     @group_id = Group.update(@group.id, :share_id => Array.new(8){rand(36).to_s(36)}.join)
    render :show
      #Group.update_all("share_id = created_at")
      # render :show
  end
  
  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group.destroy
    respond_to do |format|
      format.html { redirect_to groups_url, notice: 'Group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def polls
    @polls = @group.polls.order(created_at: :desc).limit(25).paginate(:page => params[:page], :per_page => 25)
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_group
    @group = Group.find(params[:id])
   end

  # Never trust parameters from the scary internet, only allow the white list through.
  def group_params
    params.permit(:name, :share_id,  :description, :image, :privacy, :admins_can_add_users, :members_can_create_polls)
  end
end
