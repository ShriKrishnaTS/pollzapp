json.unread_count @notifications.where(read: false).count
json.data (@polls) do |poll|
  json.extract! poll, :id, :question, :title, :ends_on, :image_1, :image_2, :option_1, :option_2
  json.name poll.user.name
  json.username poll.user.username
  json.has_others_voted (poll.votes.count > 0)
  json.voted @current_user.voted_polls.include? @poll
  json.thumbnail poll.composite.thumbnail.url
  json.comments_count poll.comments.count
  json.video poll.video? ? poll.video.url : nil
    read_status = @current_user.poll_read_statuses.where(poll_id: poll.id).first_or_create
  json.read_status read_status.read
  json.last_viewed read_status.last_viewed
  json.comments_enabled (poll.ends_on + 48.hours) > Time.now && poll.comments_enabled
  json.comments_read poll.comments.where('created_at > ?', read_status.last_viewed).count == 0
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
  elsif (poll.ends_on - 20.minutes) < Time.now
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
  json.voted @current_user.voted_polls.include? poll
  json.tags poll.tags.map(&:name).join(', ')

end 


json.pagination do
   json.current_page @polls.current_page
   json.per_page @polls.per_page
   json.total_entries @polls.total_entries
end