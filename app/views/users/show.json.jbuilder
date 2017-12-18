json.extract! @user, :id, :name, :username, :phone, :join_request_sent
json.thumbnail @user.image.thumbnail.url
json.votes_count @user.votes.count
json.groups_count @user.user_groups.active.where(blocked: false).includes(:group).where.not(groups: {privacy: 2} && {deleted: 1}).count
json.polls_count @user.polls.count
json.my_contact @my_contact
json.groups @user.user_groups.active.where(blocked: false).includes(:group).where.not(groups: {privacy: 2} || {deleted: 1}) do |gu|
  json.id gu.group_id
  json.name gu.group.name
  json.user_type gu.user_type
  json.users_count gu.group.group_users.active.where(blocked: false).includes(:user).where(users:{disabled: 0}).count

  json.privacy gu.group.privacy
  json.polls_count gu.group.polls.count
  json.votes_count gu.group.votes.count
  json.thumbnail gu.group.image.thumbnail.url
end
