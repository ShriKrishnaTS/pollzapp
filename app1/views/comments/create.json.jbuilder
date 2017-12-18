json.extract! @comment, :id, :poll_id, :body
json.created_at @comment.created_at.strftime('%b %d, %I:%M %p')
json.me @comment.user_id == @current_user.id
json.user do
  json.name @comment.user.name
  json.thumbnail @comment.user.image.thumbnail.url
end