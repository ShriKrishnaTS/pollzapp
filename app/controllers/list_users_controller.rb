class ListUsersController < ApplicationController
  before_action :authenticate_admin!

  def index
    @allUsers=User.where disabled: false
    render :layout => "layouts/dashboard"
  end

  def destroy
    @user=User.find params[:id]
    @groups= @user.user_groups

    @groups.each do |group|
      if group.group.group_users.count>1
        if group.user_type=='Group Owner' ||group.user_type==2

          @newOwner=group.group.group_users.where(user_type: 1).order(created_at: 'DESC').first
          if !@newOwner
            @newOwner=group.group.group_users.where(user_type: 0).order(created_at: 'DESC').first
          end
          @newOwner.user_type='Group Owner'
          @newOwner.save
          Notification.create user_id: @newOwner.user.id,
                              group_id: group.group.id,
                              name: @newOwner.user.name,
                              username: @newOwner.user.username,
                              image: group.group.image.url,
                              user_image: @newOwner.user.image.url,
                              group_title: group.group.name,
                              creator_id: nil,
                              description: 'Owner has been removed by @pollzapp from [groupname], You are now the owner',
                              link: 'pages/group/screen',
                              code: '105',
                              text: 'Owner has been removed by @pollzapp from' + group.group.name + ', You are now the owner.', parts: [
                  {text: '@pollzapp', link: nil, context: {id: @newOwner.user.id}},
                  {text: '@pollzapp', link: nil, context: {id: @newOwner.user.id}},
                  {text: nil, link: nil, context: {id: @newOwner.user.id}},
                  {text: 'Owner has been removed by @pollzapp from [groupname], You are now the owner', link: 'pages/group/screen', context: {group: {id: group.group.id}}},
                  {text: nil, link: 'pages/group/screen', context: {group: {id: group.group.id}}},
                  {text: group.group.image.thumbnail.url, link: nil, context: {group: {id: group.group.id}}},
                  {text: group.group.name, link: nil, context: {group: {id: group.group.id}}},
                  {text: 'Owner has been removed by @pollzapp from' + group.group.name + ', You are now the owner.', link: 'pages/group/screen', context: {group: {id: group.group.id}}},
              ], icon: group.group.image


          group.delete
        end
      else
        group.group.deleted=true
        group.group.save
        group.delete
      end
    end

    @user.disabled=true
    @user.save
    redirect_to :back
  end

  def deleted
    @allUsers = User.where disabled: true
    render :layout => "layouts/dashboard"
  end

  def restore
    @user=User.find params[:id]
    @user.disabled=false
    @user.save
    redirect_to :back

  end
end
