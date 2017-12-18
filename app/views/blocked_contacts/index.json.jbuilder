json.array! @contacts do |c|
  json.extract! c, :id, :user_id
  json.extract! c.contact, :name, :username
  json.thumbnail c.contact.image.thumbnail.url
end
