json.array! @comments do |c|
  json.extract! c, :id, :poll_id, :body, 
  json.created_at c.created_at.strftime('%b %d, %I:%M %p')
  json.me c.user_id == @current_user.id
  json.user do
    json.id c.user, :id
    json.name c.user, :name
    json.name c.user, :username

    json.thumbnail c.user.image.thumbnail.url
  end
end
