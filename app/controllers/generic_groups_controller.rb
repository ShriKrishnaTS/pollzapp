class GenericGroupsController < ApplicationController
	 before_action :authenticate_admin!
        layout "dashboard"


  def index
    @Generic=Group.where id: '1'
    render :layout => "layouts/dashboard"
  end
  
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
          mute_till = u.user_groups.find_by_group_id(@poll.group_id).mute_till
         if !mute_till || mute_till < Time.now
            n = Notification.create user_id: u.id, group_id: @poll.group_id, poll_id: @poll.id,
                                    name:'pollzapp',
                                    username:'pollzapp',
                                    image:@poll.group.image.url,
                                   
                                    poll_title:"#{@poll.title.upcase}",
                                    group_title:@poll.group.name,
                                    creator_id:1,
                                    description:'pollzapp posted a new poll [POLLTITLE] in [groupname] ',
                                    link: 'pages/poll/screen',
                                    code: '110',
                                    text: 'pollzapp posted a new poll ' + "#{@poll.title.upcase}" + ' in ' + @poll.group.name,
                                    parts: [
                                     
                                        {poll_id: @poll.id, link: 'pages/poll/screen', context: {poll: poll}},
                                        {group_id: @poll.group.id, link: nil, context: {group: {id: @poll.group_id}}},
                                        
                                      
                                        {description: ' posted a new poll ', link: nil, context: nil},
                                        {poll_title: @poll.title, link: 'pages/poll/screen', context: {poll: poll}},
                                        {group_image: @poll.group.image.thumbnail.url, link: nil, context: {group: {id: @poll.group_id}}},
                                        {group_name: @poll.group.name, link: nil, context: {group: {id: @poll.group_id}}}],
                                    icon: @poll.composite
          end
        end
      end
     render "show"
    else
      render json: @poll.errors, status: :unprocessable_entity
    end
  end
  private
  def set_poll
    @poll = Poll.find(params[:id])
  end

  def poll_params
    params.permit(:title, :video, :duration, :group_id, :question, :image_1, :image_2, :option_1, :option_2, :comments_enabled)
  end
end
