class ListGroupsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @allGroups=Group.where deleted: false
    render :layout => "layouts/dashboard"
  end

  def show
    @group=Group.find(params[:id])
    render :layout => "layouts/dashboard"
  end

  def update
    group=Group.find params[:id]

    if params[:make_owner].present?
      oldOwner=group.group_users.where(user_type: "Group Owner").first
      if oldOwner
        oldOwner.user_type='Member'
        oldOwner.save
      end
      @newOwner=group.group_users.where(id: params[:make_owner]).first
      @newOwner.user_type='Group Owner'
      @newOwner.save
      Notification.create user_id: @newOwner.user.id,
                          group_id: group.id,
                          name: @newOwner.user.name,
                          username: @newOwner.user.username,
                          image: group.image.url,
                          user_image: @newOwner.user.image.url,
                          group_title: group.name,
                          creator_id: nil,
                          description: 'Owner has been removed by @pollzapp from [groupname], You are now the owner',
                          link: 'pages/group/screen',
                          code: '105',
                          text: 'Owner has been removed by @pollzapp from' + group.name + ', You are now the owner.', parts: [
              {text: '@pollzapp', link: nil, context: {id: @newOwner.user.id}},
              {text: '@pollzapp', link: nil, context: {id: @newOwner.user.id}},
              {text: nil, link: nil, context: {id: @newOwner.user.id}},
              {text: 'Owner has been removed by @pollzapp from [groupname], You are now the owner', link: 'pages/group/screen', context: {group: {id: group.id}}},
              {text: nil, link: 'pages/group/screen', context: {group: {id: group.id}}},
              {text: group.image.thumbnail.url, link: nil, context: {group: {id: group.id}}},
              {text: group.name, link: nil, context: {group: {id: group.id}}},
              {text: 'Owner has been removed by @pollzapp from' + group.name + ', You are now the owner.', link: 'pages/group/screen', context: {group: {id: group.id}}},
          ], icon: group.image

    end
    if params[:make_admin].present?
      @newOwner=group.group_users.where(id: params[:make_admin]).first
      @newOwner.user_type='Group Admin'
      @newOwner.save
    end
    if params[:revoke_admin].present?
      @newOwner=group.group_users.where(id: params[:revoke_admin]).first
      @newOwner.user_type='Member'
      @newOwner.save
    end

    redirect_to :back
  end

  def destroy
    @group=Group.find(params[:id])
    @group.deleted=true
    @group.save
    @group.group_users.each do |gu|
      Notification.create user_id: gu.user_id,
                          group_id: gu.group_id,
                          name: gu.user.name,
                          username: gu.user.username,
                          image: gu.group.image.url,
                          user_image: gu.user.image.url,
                          group_title: gu.group.name,
                          creator_id: gu.user.id,
                          link: nil,
                          code: '115',
                          description: 'The group [groupname] has been deleted', text: 'The group '+gu.group.name+' has been deleted', parts: [
              {text: '@pollzapp', link: nil, context: {id: gu.user_id}},
              {text: '@pollzapp', link: nil, context: {id: gu.user_id}},
              {text: nil, link: nil, context: {id: gu.user_id}},
              {text: 'The group [groupname] has been deleted', link: nil, context: {group: {id: gu.group_id}}},
              {text: nil, link: nil, context: {group: {id: gu.group_id}}},
              {text: gu.group.image.thumbnail.url, link: nil, context: {group: {id: gu.group_id}}},
              {text: gu.group.name, link: nil, context: {group: {id: gu.group_id}}},
              {text: 'The group [groupname] has been deleted', link: nil, context: {group: {id: gu.group_id}}}
          ], icon: gu.group.image
    end

    redirect_to :back
  end

  def deleted
    @allGroups = Group.where deleted: true
    render :layout => "layouts/dashboard"
  end

  def restore
    group = Group.find params[:id]
    group.deleted=false
    group.save
    redirect_to :back
  end

end
