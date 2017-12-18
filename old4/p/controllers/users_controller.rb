  class UsersController < ApplicationController
  include Authenticate

  def index
    @contacts = @current_user.contacts.where("users.name LIKE ?", "%#{params[:q]}%")
    @others = User.where("username LIKE ?", "%#{params[:q]}%").where.not(id: @contacts.map(&:id))
    @group_users = GroupUser.where(group_id: params[:group_id]).map(&:user_id)
    @users = (@contacts + @others).reject{|u| @group_users.include? u.id}
  end

  def show
    @user = User.find(params[:id])
    @my_contact = @current_user.contacts.include? @user
  end
  def update
    @user = User.find(params[:id])
     if @user.update(user_params)
      render :show, status: :ok, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy 
  end

  def check_username
    user = User.find_by_username params[:username]
    render json: {exists: user.present?}
  end

   def user_params
    params.permit(:name, :username)
  end
end

