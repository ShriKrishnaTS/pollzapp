json.pollzapp_contacts @pollzapp_contacts do |u|
  json.id u.id
  json.blocked u.blocked
  json.user_details do
    json.id u.contact.id
    json.name u.contact.name
    json.username u.contact.username
    json.phone u.contact.phone
    json.groups_count u.contact.user_groups.active.where(blocked: false).count
    json.polls_count u.contact.polls.count
    json.votes_count u.contact.votes.count
    if u.contact.image?
      json.thumbnail u.contact.image.thumbnail.url
    else
      json.thumbnail nil
    end
  end
end
json.other_contacts @other_contacts do |u|
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
