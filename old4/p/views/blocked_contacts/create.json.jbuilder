if @contact.errors && @contact.errors.size > 0
  json.array! @contact.errors.full_messages
else
  json.extract! @contact, :id, :user_id
  json.name @contact.user.name
  json.image @contact.user.image
end
