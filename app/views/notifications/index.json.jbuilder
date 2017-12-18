json.unread_count @notifications.where(read: false).count
json.notifications @notifications do |notification|
  json.extract! notification, :id, :text
  json.group_id notification.group_id
  json.poll_id notification.poll_id
  json.group_image notification.image
  json.name notification.name
  json.username notification.username
  json.user_image notification.user_image
  json.user_id notification.creator_id
  json.poll_title notification.poll_title
  json.group_title notification.group_title
  json.link notification.link
  json.description notification.description
  json.code notification.code
end

json.voted_polls @current_user.voted_polls do |vp|
  json.extract! vp,  :id

end