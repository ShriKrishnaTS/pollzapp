json.id @current_user.id
json.name @current_user.name
json.username @current_user.username
if @current_user.image.url.present?
  json.thumbnail @current_user.image.thumbnail.url
else
  json.thumbnail nil
end
json.image @current_user.image.url.present?
json.language @current_user.language
json.registered_on @current_user.created_at
json.notifications_enabled @current_user.notifications_enabled
