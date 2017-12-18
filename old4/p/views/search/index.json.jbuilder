json.people @people do |user|
  json.extract! user, :id, :name, :username
  json.thumbnail user.image.thumbnail.url
  json.groups_count user.user_groups.active.where(blocked: false).includes(:group).where.not(groups: {privacy: 2}).count
  json.polls_count user.polls.count
  json.votes_count user.votes.count
end
json.polls @polls do |poll|
  json.extract! poll, :id, :question, :title, :ends_on, :image_1, :image_2, :option_1, :option_2
  json.comments_count poll.comments.count
  json.video poll.video? ? poll.video.url : nil
 read_status = @current_user.poll_read_statuses.first_or_create(poll_id: poll.id)
  json.read_status read_status.read
  json.last_viewed read_status.last_viewed
  json.comments_enabled (poll.ends_on + 48.hours) > Time.now && poll.comments_enabled
  json.comments_read poll.comments.where('created_at > ?', read_status.last_viewed).count == 0
  json.thumbnail poll.composite.thumbnail.url
  json.current_user_type poll.group.users.include?(@current_user) ?   
  poll.group.group_users.find_by_user_id(@current_user.id).active &&  poll.group.group_users.find_by_user_id(@current_user.id).user_type : nil  
  if poll.ends_on > Time.now
  diff = Time.at((poll.ends_on-Time.now).to_i.abs)
  days = diff.utc.strftime("%-d")
  hours = diff.utc.strftime("%k")
  minutes = diff.utc.strftime("%M")
  remaining_time = "#{days.to_i-1 > 0 ? (days.to_i-1).to_s + 'd ' : ''}#{hours.to_i > 0 ? (hours.to_i).to_s + 'h ' : ''}#{minutes.to_i > 0 ? minutes + 'm' : ''}"
else
  remaining_time = nil
end
 json.remaining_time remaining_time
  if poll.ends_on < Time.now
    json.badge_text 'Ended'
    json.badge_type 'alert'
  elsif (poll.ends_on - 20.minutes) < Time.now && (!@current_user.voted_polls.include? poll)
    json.badge_text 'Ending'
    json.badge_type 'alert-outline'
  elsif (!@current_user.voted_polls.include? poll)
    json.badge_text 'New'
    json.badge_type 'info'
  else
    json.badge_text ''
    json.badge_type ''
  end
  json.group do
    json.extract! poll.group, :id, :privacy, :name
    json.thumbnail poll.group.image.thumbnail.url
  end
  json.voted @current_user.voted_polls.include? @poll
  json.tags poll.tags.map(&:name).join(', ')
end
json.groups @groups do |g|
  json.id g.id
  json.name g.name
  json.description g.description
  group_user = g.group_users.find_by_user_id(@current_user.id)
  json.group_user_id group_user ? group_user.id : nil
  json.user_type group_user ? group_user.user_type : nil
  json.user_active @group_user ? @group_user.active && !@group_user.blocked : false
  json.users_count g.group_users.active.where(blocked: false).count
  json.users_count g.group_users.unblocked.active.count
  json.polls_count g.polls.count
  json.votes_count g.votes.count
  json.privacy g.privacy
  json.thumbnail g.image.thumbnail.url
end