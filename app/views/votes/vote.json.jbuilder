json.extract! @vote.poll, :id, :question, :title, :ends_on, :image_1, :image_2, :option_1, :option_2, :comments_enabled, :result
json.comments_count 0
json.thumbnail @vote.poll.composite.thumbnail.url
json.group_description @users_list_text
json.remaining_time @vote.poll.ends_on > Time.now ? distance_of_time_in_words(Time.now, @vote.poll.ends_on).gsub('about ', '') : nil
if @vote.poll.ends_on < Time.now
  json.badge_text 'Ended'
  json.badge_type 'alert'
elsif (@vote.poll.ends_on - 20.minutes) <= Time.now
  json.badge_text 'Ending'
  json.badge_type 'alert'
elsif (@vote.poll.created_at + 20.minutes) >= Time.now
  json.badge_text 'New'
  json.badge_type 'info'
else
  json.badge_text ''
  json.badge_type ''
end
json.group do
  json.extract! @vote.poll.group, :id, :privacy, :name
  json.thumbnail @vote.poll.group.image.thumbnail.url
end
json.user do
  json.extract! @vote.poll.user, :id, :name
  json.thumbnail @vote.poll.user.image.thumbnail.url
end
json.voted @current_user.voted_polls.include? @vote.poll
json.show_results @current_user.voted_polls.include? @vote.poll || @vote.poll.ends_on < Time.now
json.extendable @vote.poll.ends_on > Time.now
json.editable false
json.result do
  json.option_1 @option_1_result
  json.option_2 @option_2_result
end