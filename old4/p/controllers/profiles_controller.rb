	class ProfilesController < ApplicationController
  include Authenticate
  # GET /profile/1
  # GET /profile/1.json
  def show
  end
  # PATCH/PUT /profile/1
  # PATCH/PUT /profile/1.json
  def update
    new_user = !@current_user.username && user_params[:username].present?
    if @current_user.update(user_params)
      if (new_user)
        
        users = UserContact.where(phone: @current_user.phone)
        users.each do |gu|
                 Notification.create user_id: gu.user_id, 
                         name:@current_user.name, 
               username:@current_user.username, 
               creator_id:@current_user.id,
               user_image:@current_user.image.url, 
               link: 'pages/profile/screen',
               description: '[User] has joined Pollzapp ',
               code: '106',
       text: @current_user.username + ' has joined pollzapp', parts: [
              {text: @current_user.username+ ' has joined pollzapp', link: 'pages/profile/screen', context: {user: {id: @current_user.id}}}
          ], icon: @current_user.image
           end
      end
      render :show
    else
      render json: @current_user.errors.full_messages, status: 422
    end
  end
    def delete_image
         @profile = User.find(params[:id])
         @profile.remove_image!
         @profile.save
         render :show
      end
 
  private
  def user_params
    params.permit(:name, :username, :image, :language, :notifications_enabled)
  end
end
