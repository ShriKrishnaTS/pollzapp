class CommentsController < ApplicationController
  include Authenticate

  def index
    @comments = Comment.where poll_id: params[:poll_id]
  end

  def create
    @comment = Comment.new params.permit(:poll_id, :body)
    @comment.user = @current_user
    if @comment.save
      read_status = @current_user.poll_read_statuses.first_or_create(poll_id: @comment.poll_id)
      read_status.update(last_viewed: Time.now, read: true)

        @comment.poll.group.group_users.active.unblocked.each do |u|
        logger.info u
                u = u.user

        unless u.id == @current_user.id
          poll = {
              user: {}, group: {}, id: @comment.poll_id, result: {}, comments: [], image: {}, image_1: {}, image_2: {}
          }
  	  mute_till = u.user_groups.find_by_group_id(@comment.poll.group_id).mute_till
          if !mute_till || mute_till < Time.now
          n = Notification.create user_id: u.id,group_id: @comment.poll.group_id, poll_id: @comment.poll.id,
          name:@comment.user.name, 
          username:@comment.user.username, 
          image:@comment.poll.group.image.url, 
          user_image:@comment.user.image.url, 
          poll_title:"#{@comment.poll.title.upcase}", 
          group_title:@comment.poll.group.name,
          creator_id:@comment.user_id,
          description:'[User] has commented in poll [POLLTITLE]',
          link: 'pages/poll/screen', 
          code: '111',
          text: 'New comment in poll ' + "#{@comment.poll.title.upcase}", parts: [
                {user_id: @comment.user.id, link: nil, context: {id: @comment.user_id}},
                {poll_id: @comment.id, link: 'pages/poll/screen', context: {poll: poll}},
                {group_id: @comment.poll.group.id, link: nil, context: nil},
                {name: @comment.user.name, link: nil, context: {id: @comment.user_id}},
                {username: @comment.user.username, link: nil, context: {id: @comment.user_id}},
                {user_image: @comment.user.image.thumbnail.url, link: nil, context: {id: @comment.user_id}},
                {description: ' New comment in poll  ', link: nil, context: nil},
                {poll_title:@comment.poll.title, link: 'pages/poll/screen', context: {poll: poll}},
                {poll_image: @comment.poll.group.image.thumbnail.url, link: nil, context: {group: {id: @comment.poll.group_id}}},
                {comment_image: @comment.poll.group.name, link: nil, context: {group: {id: @comment.poll.group_id}}},
              
          ], icon: @comment.poll.composite
        end 
      end
end
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end
end
