json.array!(@user_contacts) do |u|
  json.id u.id
  json.blocked u.blocked
  json.user_details do
    json.id u.contact.present? ? u.contact.id : nil
    json.name u.contact.present? ? u.contact.name : u.name
    json.username u.contact.present? ? u.contact.username : nil
    json.phone u.contact.present? ? u.contact.phone : u.phone
    if u.contact.present? and u.contact.image?
      json.thumbnail u.contact.image.thumbnail.url
    else
      json.thumbnail nil
    end
  end
end
