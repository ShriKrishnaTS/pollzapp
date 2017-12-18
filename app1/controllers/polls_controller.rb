class PollsController < ApplicationController
  before_action :set_poll, only: [:show, :update, :destroy]
  include Authenticate

  def index
    @polls = Poll.where(group_id: @current_user.user_groups.active.unblocked.map(&:group_id)).order(updated_at: :desc).paginate(:page => params[:page], :per_page => 25)
    @notifications = @current_user.notifications.order(created_at: :desc).limit 500
  end

  def create
    @poll = Poll.new poll_params
    @poll.ends_on = params[:duration].to_i.hours.from_now
    @poll.user = @current_user
    tag_names = params[:tags].to_s.split(/[\s,']/)
    @poll.tags = tag_names.map do |tag_name|
      Tag.where(name: tag_name.downcase.strip).first_or_create
    end
    if @poll.image_1.present?
      @poll.image_1.resize_to_fit(400, 400)
      if @poll.image_2.present?
        @poll.image_2.resize_to_fit(400, 400)
        composite = Magick::ImageList.new(@poll.image_1.path, @poll.image_2.path).append(false)
        temp_file = Tempfile.new(['composite_image', '.jpg'])
        composite.write temp_file.path
        @poll.composite = temp_file
      else
        @poll.composite = Pathname.new(@poll.image_1.path).open
      end
    end
    if @poll.save 
      @poll.group.group_users.active.unblocked.each do |gu|
        u = gu.user
        unless u.id == @poll.user_id
          poll = {
              user: {}, group: {}, id: @poll.id, result: {}, comments: [], image: {}, image_1: {}, image_2: {}
          }
          group = {id: @poll.group_id}
          n = Notification.create user_id: u.id, group_id: @poll.group_id, poll_id: @poll.id,
          name:@poll.user.name, 
          username:@poll.user.username, 
          image:@poll.group.image.url, 
          user_image:@poll.user.image.url, 
          poll_title:"#{@poll.title.upcase!}", 
          group_title:@poll.group.name,
          creator_id:@poll.user.id, 
          description:'[User] posted a new poll [POLLTITLE] in [groupname] ',
          link: 'pages/poll/screen',
          code: '110',
          text: @poll.user.username + ' posted a new poll ' + "#{@poll.title.upcase!}" + ' in ' + @poll.group.name, parts: [
                {user_id: @poll.user.id, link: nil, context: {id: @poll.user_id}},
                {poll_id: @poll.id, link: 'pages/poll/screen', context: {poll: poll}},
                {group_id: @poll.group.id, link: nil, context: {group: {id: @poll.group_id}}},
                {name: @poll.user.name, link: nil, context: {id: @poll.user_id}},
                {username: @poll.user.username, link: nil, context: {id: @poll.user_id}},
                {user_image: @poll.user.image.thumbnail.url, link: nil, context: {id: @poll.user_id}},
                {description: ' posted a new poll ', link: nil, context: nil},
                {poll_title: "(@poll.title.upcase!}", link: 'pages/poll/screen', context: {poll: poll}},
                {group_image: @poll.group.image.thumbnail.url, link: nil, context: {group: {id: @poll.group_id}}},
                {group_name: @poll.group.name, link: nil, context: {group: {id: @poll.group_id}}}],
                                  icon: @poll.composite
        end
      end

      render json: {message: 'Poll created', id: @poll.id}
    else
      render json: @poll.errors, status: :unprocessable_entity
    end
  end

  def show
    total = @poll.votes.count
    option_1_count = @poll.votes.where(choice: @poll.option_1).count
    users_count = @poll.group.group_users.where.not(id: @current_user.id).count
    @users_list_text = ''
    total = @poll.votes.count
    option_1_count = @poll.votes.where(choice: @poll.option_1).count
    users_count = @poll.group.group_users.where.not(id: @current_user.id) .where(blocked: false).count
    @option_1_result = total > 0 ? option_1_count*100/total : 0
    @option_2_result = total > 0 ? (total - option_1_count)*100/total : 0
    @in_group = false
    read_status = @current_user.poll_read_statuses.where(poll_id: @poll.id).first_or_create
    read_status.update(last_viewed: Time.now, read: true)
    if @poll.group.group_users.active.where(blocked: false, user_id: @current_user.id).present?
      @users_list_text += 'You, '
      @in_group = true
    end
    users_limit = @in_group ? 3 : 4
    if users_count > 3
      @users_list_text += "#{@poll.group.group_users.unblocked.active.where.not(user_id: @current_user.id).limit(users_limit).map { |gu| gu.user.username }.join(', ')} " 
    elsif users_count >= 0
      @users_list_text += @poll.group.group_users.unblocked.active.where.not(user_id: @current_user.id).limit(users_limit).map { |gu| gu.user.username }.join(', ')
    end
      users_limit = @in_group ? 3 : 4
    if users_count > 3
      @users_list_text_name = "#{@poll.group.group_users.unblocked.active.where.not(user_id: @current_user.id).limit(users_limit).map { |gu| gu.user.name  }.join(', ')} " 
    elsif users_count >= 0
      @users_list_text_name = @poll.group.group_users.unblocked.active.where.not(user_id: @current_user.id).limit(users_limit).map { |gu| gu.user.name }.join(', ')
    end
  end

  def delete_composite
         @poll = Poll.find(params[:id])
         @poll.remove_composite!
         @poll.save
         render :show
  end

  def delete_image1
       @poll = Poll.find(params[:id])
         @poll.remove_image_1!
         if @poll.image_2.present?
                 @poll.composite = Pathname.new(@poll.image_2.path).open
               else
                 @poll.remove_composite!
              end

         @poll.save
         render :show
  end
  
  def delete_image2
       @poll = Poll.find(params[:id])
         @poll.remove_image_2!
          if @poll.image_1.present?
       @poll.composite = Pathname.new(@poll.image_1.path).open
     else   @poll.remove_composite!
  end
         @poll.save
         render :show
  end

  #  def delete_comments
  #     @poll = Poll.find(params[:id])
  #       @poll.remove_comments!
  #       @poll.save
  #       render :show
  #  end
   


    def update
    duration = @poll.duration + params[:duration].to_i
    @poll.ends_on = @poll.ends_on + params[:duration].to_i.hours
    @poll.attributes = poll_params
    @poll.duration = duration
    # The video upload hack
    if params[:file]
      @poll.video = params[:file]
      @poll.image_2 = nil
    end
    if params[:tags].present?
      tag_names = params[:tags].to_s.split(/[\s,']/)
      @poll.tags = tag_names.map do |tag_name|
        Tag.where(name: tag_name.downcase.strip).first_or_create
      end
    end
    if @poll.image_1.present?
      @poll.image_1.resize_to_fit(400, 400)
      if @poll.image_2.present?
        @poll.image_2.resize_to_fit(400, 400)
        composite = Magick::ImageList.new(@poll.image_1.path, @poll.image_2.path).append(false)
        temp_file = Tempfile.new(['composite_image', '.jpg'])
        composite.write temp_file.path
        @poll.composite = temp_file
      else
        @poll.composite = Pathname.new(@poll.image_1.path).open
      end
    end
    if @poll.save
      render json: {message: 'Poll updated'}
    else
      render json: @poll.errors, status: :unprocessable_entity
    end
      if @poll.comments_enabled == false
        sql = ("DELETE FROM `comments` WHERE poll_id IN (SELECT id FROM polls WHERE comments_enabled=false)")
          
          records_array = ActiveRecord::Base.connection.execute(sql)
        end
    

  end

  def destroy
  end
   def read
    @current_user.notifications.where(read: false).update_all read: true
    render json: {message: 'Notifications marked as read'}
  end

  private
  def set_poll
    @poll = Poll.find(params[:id])
  end

  def poll_params
    params.permit(:title, :video, :duration, :group_id, :question, :image_1, :image_2, :option_1, :option_2, :comments_enabled)
  end
end
