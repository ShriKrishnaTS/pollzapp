class GroupUsersController < ApplicationController
  before_action :set_group
  before_action :set_group_user, only: [:show, :update, :destroy]
  include Authenticate
  def index
    @group_users = @group.group_users.where(blocked: false)
  end
  def show
  end
  def join
    @group_user = GroupUser.find(params[:id])
    @j = @group_user.joins.build(:user_id => current_user.id)
    respond_to do |format|
      if @j.save
        format.html { redirect_to(@group_user, :notice => 'You have joined this group.') }
        format.xml  { head :ok }
      else
        format.html { redirect_to(@group_user, :notice => 'Join error.') }
        format.xml  { render :xml => @group_user.errors, :status => :unprocessable_entity }
      end
    end
  end
  def create
   # @group_users = @group.group_users
    @group_user = @group.group_users.build(group_user_params)
    if @group.privacy == 'Closed'
      @group_user.active = false
    end
    if @group_user.save
      if !@group_user.active
        group = {id: @group.id}
        @group.group_users.where(user_type: ['Group Owner', 'Group Admin']).each do |admin|
          Notification.create user_id: admin.user_id,  group_id: @group_user.group_id,
          name:@group_user.user.name, 
          username:@group_user.user.username, 
          image:@group_user.group.image.url, 
          user_image:@group_user.user.image.url, 
          group_title:@group_user.group.name,
          creator_id:@group_user.user.id,
          description:' [User] wants to join [groupname] ',
          code: '102',  
          link: 'pages/group/screen',text: @group_user.user.username + ' wants to join ' + @group.name, parts: [
                {text: @group_user.user.name, link: nil, context: {id: @group_user.user_id}},
                {text: @group_user.user.username, link: nil, context: {id: @group_user.user_id}},
                {text: @group_user.user.image.thumbnail.url, link: nil, context: {id: @group_user.user_id}},
                {text: ' wants to join ', link: 'pages/group/screen', context: {group: {id: @group.id}}}, 
                {text: nil, link: 'pages/group/screen', context: {group: {id: @group.id}}},
                {text: @group_user.group.image.thumbnail.url, link: nil, context: {group: {id: @group_user.group_id}}},
                {text: @group_user.group.name, link: nil, context: {group: {id: @group_user.group_id}}},
                {text: @group_user.user.username + ' wants to join ' + @group.name, link: 'pages/group/screen', context: {group: {id: @group.id}}},
          ], icon: @group_user.user.image
        end
      end
      render :show, status: :created, id: @group_user.id
    else
      render json: @group_user.errors, status: :unprocessable_entity
    end
  end
  def update
    if @group_user.update group_user_params
      if params[:active]
        Notification.create user_id: @group_user.user_id, group_id: @group_user.group_id,
          name:@group_user.user.name, 
          username:@group_user.user.username, 
          image:@group_user.group.image.url, 
          user_image:@group_user.user.image.url, 
          group_title:@group.name,
          creator_id:@group_user.user.id, 
          description:'You have joined [groupname]',
          code: '103',
          link: 'pages/group/screen',text: 'You have joined ' + @group.name, parts: [
           {text: @current_user.name, link: nil, context: {id: @group_user.user_id}},
           {text: @current_user.username, link: nil, context: {id: @group_user.user_id}},
           {text: @current_user.image.thumbnail.url, link: nil, context: {id: @group_user.user_id}},
           {text: ' You have joined ', link: 'pages/group/screen', context: {group: {id: @group.id}}},
           {text: nil, link: 'pages/group/screen', context: {group: {id: @group.id}}},
           {text: @group.image.thumbnail.url, link: nil, context: {group: {id: @group_user.group_id}}},
           {text: @group.name, link: nil, context: {group: {id: @group_user.group_id}}},
           {text: 'You have joined ' + @group.name, link: 'pages/group/screen', context: {group: {id: @group.id}}},
        ], icon: @group.image
      end
      if params[:user_type] == 'Group Admin'
        Notification.create user_id: @group_user.user_id,  group_id: @group_user.group_id,
          name: @current_user.name, 
          username: @current_user.username, 
          image:@group_user.group.image.url, 
          user_image:@group_user.user.image.url, 
          group_title:@group.name,
          creator_id:@current_user.id, 
          description:'[User] has made you Admin for [groupname]',
          link: 'pages/group/screen',
          code: '107',
          text: @current_user.name + ' has made you Admin for ' + @group.name, parts: [
             {text: @current_user.name, link: nil, context: {id: @group_user.user_id}},
             {text: @current_user.username, link: nil, context: {id: @group_user.user_id}},
             {text: nil},
             {text: ' has made you Admin for ', link: 'pages/group/screen', context: {group: {id: @group_user.group_id}}},
             {text: nil, link: 'pages/group/screen', context: {group: {id: @group_user.group_id}}},
             {text: @group.image.thumbnail.url, link: nil, context: {group: {id: @group_user.group_id}}},
             {text: @group.name, link: nil, context: {group: {id: @group_user.group_id}}},
             {text: @current_user.name + ' has made you Admin for ' + @group.name, link: 'pages/group/screen', context: {group: {id: @group.id}}}
          ], icon: @group.image
      end
      render :show, status: :created, location: @group_user
    else
      render json: @group_user.errors, status: :unprocessable_entity
    end
  end
  def destroy
    if @group_user.user_type == 'Group Owner'
      if @group.group_users.owners.count == 1
        next_owner = @group.group_users.order("RAND()").first
        if next_owner
          next_owner.update user_type: 'Group Owner'
          Notification.create user_id: next_owner.user_id,
           group_id: @group_user.group_id,
          name:@group_user.user.name, 
          username:@group_user.user.username, 
          image:@group_user.group.image.url, 
          user_image:@group_user.user.image.url, 
          group_title:@group.name,
          creator_id:@group_user.user.id, 
          description:'[User] has left [groupname], you are now the owner',
             link: 'pages/group/screen',
             code: '105',
          link: 'pages/group/screen', text: @current_user.username + ' has left ' + @group.name + ', You are now the owner.', parts: [
                {text: @current_user.name, link: nil, context: {id: @group_user.user_id}},
                {text: @current_user.username, link: nil, context: {id: @group_user.user_id}},
                {text: @current_user.image.thumbnail.url, link: nil, context: {id: @group_user.user_id}},
                {text: ' has left, You are now the owner. ', link: 'pages/group/screen', context: {group: {id: @group.id}}},
                {text: nil, link: 'pages/group/screen', context: {group: {id: @group.id}}},
                {text: @group.image.thumbnail.url, link: nil, context: {group: {id: @group_user.group_id}}},
                {text: @group.name, link: nil, context: {group: {id: @group_user.group_id}}},
                {text: @current_user.username + ' has left ' + @group.name + ', You are now the owner.', link: 'pages/group/screen', context: {group: {id: @group.id}}},
          ], icon: @group.image
        end
      else
        next_owner = @group.group_users.owners.where.not(id: @group_user.id).first
        Notification.create user_id: next_owner.user_id, 
           group_id: @group_user.group_id,
          name:@group_user.user.name, 
          username:@group_user.user.username, 
          image:@group_user.group.image.url, 
          user_image:@group_user.user.image.url, 
          group_title:@group.name,
          creator_id:@group_user.user.id, 
          description:'[User] has left [groupname], You are now the owner',
             link: 'pages/group/screen',
             code: '105',
          text: @current_user.username + ' has left ' + @group.name + ', You are now the owner.', parts: [
                {text: @current_user.name, link: nil, context: {id: @group_user.user_id}},
                {text: @current_user.username, link: nil, context: {id: @group_user.user_id}},
                {text: @current_user.image.thumbnail.url, link: nil, context: {id: @group_user.user_id}},
                {text: ' has left, You are now the owner. ', link: 'pages/group/screen', context: {group: {id: @group.id}}},
                {text: nil, link: 'pages/group/screen', context: {group: {id: @group.id}}},
                {text: @group.image.thumbnail.url, link: nil, context: {group: {id: @group_user.group_id}}},
                {text: @group.name, link: nil, context: {group: {id: @group_user.group_id}}},
                {text: @current_user.username + ' has left ' + @group.name + ', You are now the owner.', link: 'pages/group/screen', context: {group: {id: @group.id}}},
        ], icon: @group.image
      end
    end
    if @group_user.active
      if @current_user.id != @group_user.user_id
        Notification.create user_id: @group_user.user_id, 
        group_id: @group_user.group_id,
          name:@group_user.user.name, 
          username:@group_user.user.username, 
          image:@group_user.group.image.url, 
          user_image:@group_user.user.image.url, 
          group_title:@group.name,
          creator_id:@group_user.user.id, 
          link: 'pages/group/screen',
          code: '108',
          description:'You have been kicked from [groupname]',text: 'You have been kicked from ' + @group.name, parts: [
              {text: @current_user.name, link: nil, context: {id: @group_user.user_id}},
              {text: @current_user.username, link: nil, context: {id: @group_user.user_id}},
              {text: @current_user.image.thumbnail.url, link: nil, context: {id: @group_user.user_id}},
              {text: ' You have been kicked from ',  link: 'pages/group/screen', context: {group: {id: @group.id}}},
              {text: nil,  link: 'pages/group/screen', context: {group: {id: @group.id}}},
              {text: @group.image.thumbnail.url, link: nil, context: {group: {id: @group_user.group_id}}},
              {text: @group.name, link: nil, context: {group: {id: @group_user.group_id}}},
              {text: 'You have been kicked from ' + @group.name,  link: 'pages/group/screen', context: {group: {id: @group.id}}}
        ], icon: @group.image
      end
    else
      Notification.create user_id: @group_user.user_id,
       group_id: @group_user.group_id,
          name:@group_user.user.name, 
          username:@group_user.user.username, 
          image:@group_user.group.image.url, 
          user_image:@group_user.user.image.url, 
          group_title:@group.name,
          creator_id:@group_user.user.id, 
          link: 'pages/group/screen',
              description:'You have been rejected by [groupname]',
              code:'104', text: 'You have been rejected by ' + @group.name, parts: [
          {text: @current_user.name, link: nil, context: {id: @group_user.user_id}},
          {text: @current_user.username, link: nil, context: {id: @group_user.user_id}},
          {text: @current_user.image.thumbnail.url, link: nil, context: {id: @group_user.user_id}},
          {text: ' You have been rejected by ',  link: 'pages/group/screen', context: {group: {id: @group.id}}},
          {text: nil,  link: 'pages/group/screen', context: {group: {id: @group.id}}},
          {text: @group.image.thumbnail.url, link: nil, context: {group: {id: @group_user.group_id}}},
          {text: @group.name, link: nil, context: {group: {id: @group_user.group_id}}},
          {text: 'You have been rejected by ' + @group.name,  link: 'pages/group/screen', context: {group: {id: @group.id}}},
      ], icon: @group.image
    end
    @group_user.destroy
    render json: {message: 'User removed from group'}
  end
  def bulk_add
   params[:users].each do |id|
      gu = @group.group_users.create user_type: 'Member', user_id: id, active: true
      group = {}
      n = Notification.create user_id: id,  
      link: 'pages/group/screen',
       description:'[User] added you to [groupname]',
       code: '101',
        group_title:@group.name,
        group_id:@group.id,
        group_title: @group.name,
        image: @group.image.url,
        username: @current_user.username,
        name: @current_user.name,
         creator_id:@current_user.id, 
     text: @current_user.username + ' added you to ' + @group.name, parts: [
          {text: @current_user.username + ' added you to ' + @group.name, link: 'pages/group/screen', context: {group: {id: @group.id}}}], icon: @current_user.image
    end
    render json: {message: 'Users added to group'}
  end
  def blocked
    @group_users = @group.group_users.active.where(blocked: true)
  end
  private
  def set_group
    @group = Group.find(params[:group_id])
  end
  def set_group_user
    @group_user = @group.group_users.find(params[:id])
  end
  def group_user_params
    params.permit(:group_id, :user_id, :user_type, :active, :blocked, :mute_till)
  end
end