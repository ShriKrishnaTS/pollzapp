json.data (@groups.map(&:group)) do |g|
    if g.deleted == false

  json.extract! g, :id, :name, :description, :privacy, :admins_can_add_users, :members_can_create_polls, :share_id, :generic
  json.group_user_id g.group_users.find_by_user_id(@current_user.id).id
  json.user_type g.group_users.find_by_user_id(@current_user.id).user_type
  json.users_count g.group_users.unblocked.active.includes(:user).where(users:{disabled: 0}).count
  json.polls_count g.polls.count
  json.votes_count g.votes.count
  json.thumbnail g.image.thumbnail.url
end
end
json.pagination do
   json.current_page @groups.current_page
   json.per_page @groups.per_page
   json.total_entries @groups.total_entries
end
