json.extract! @poll, :id, :question, :title, :ends_on, :image_1, :image_2, :option_1, :option_2
json.comments_enabled (@poll.ends_on + 48.hours) > Time.now && @poll.comments_enabled
  if @poll.media_disabled == false
json.thumbnail @poll.composite.thumbnail.url
json.image @poll.composite.url
else 
json.thumbnail nil
json.image nil
end
json.video @poll.video? ? @poll.video.url : nil
json.comments_count @poll.comments.count
json.group_description @poll.group.description
json.group_members @users_list_text
json.group_members_name @users_list_text_name

json.group_users_count @poll.group.group_users.unblocked.active.count
json.in_group @in_group
json.current_user_type @poll.group.users.include?(@current_user) ? @poll.group.group_users.find_by_user_id(@current_user.id).user_type : nil
json.ended @poll.ends_on < Time.now
if @poll.ends_on > Time.now
  diff = Time.at((@poll.ends_on-Time.now).to_i.abs)
  days = diff.utc.strftime("%-d")
  hours = diff.utc.strftime("%k")
  minutes = diff.utc.strftime("%M")
  remaining_time = "#{days.to_i-1 > 0 ? (days.to_i-1).to_s + 'd ' : ''}#{hours.to_i > 0 ? (hours.to_i).to_s + 'h ' : ''}#{minutes.to_i > 0 ? minutes + 'm' : ''}"
else
  remaining_time = nil
end
json.remaining_time remaining_time
if @poll.ends_on < Time.now
  json.badge_text 'Ended'
  json.badge_type 'alert'
elsif (@poll.ends_on - 20.minutes) < Time.now
  json.badge_text 'Ending'
  json.badge_type 'alert-outline'
elsif (!@current_user.voted_polls.include? @poll)
  json.badge_text 'New'
  json.badge_type 'info'
else
  json.badge_text ''
  json.badge_type ''
end
json.group do
  json.extract! @poll.group, :id, :privacy, :name
  json.thumbnail @poll.group.image.thumbnail.url
end
json.user do
if @poll.group_id != 1
  json.extract! @poll.user, :id, :name, :username, :disabled
  json.thumbnail @poll.user.image.thumbnail.url
end
end
json.voted @current_user.voted_polls.include? @poll
json.has_others_voted (@poll.votes.count > 0)
json.show_results @current_user.voted_polls.include?(@poll) || @poll.ends_on < Time.now
json.extendable ((@poll.created_at + 96.hours - @poll.ends_on)/3600).to_i
json.editable @poll.votes.count == 0 && (@poll.created_at + 20.minutes) > Time.now
json.result do
  json.option_1 @option_1_result
  json.option_2 @option_2_result
end
json.tags @poll.tags.map(&:name)
json.comments @poll.comments.order(created_at: :desc) do |c|
  json.extract! c, :id, :poll_id, :body
  json.created_at c.created_at
  json.user do
    json.id c.user.id
    json.name c.user.name
    json.username c.user.username
    json.thumbnail c.user.image.thumbnail.url
  end
end
