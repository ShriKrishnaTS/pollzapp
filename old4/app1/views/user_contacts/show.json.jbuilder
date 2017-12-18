json.id @user_contact.id
json.blocked @user_contact.blocked
json.user_details do
  json.id @user_contact.contact.present? ? @user_contact.contact.id : nil
  json.name @user_contact.contact.present? ? @user_contact.contact.name : @user_contact.name
  json.username @user_contact.contact.present? ? @user_contact.contact.username : nil
  json.phone @user_contact.contact.present? ? @user_contact.contact.phone : @user_contact.phone
  if @user_contact.contact.present? and @user_contact.contact.image?
    json.thumbnail @user_contact.contact.image.thumbnail.url
  else
    json.thumbnail nil
  end
end
