json.users @group_users.active do |group_user|
    if group_user.user.disabled == false

  json.extract! group_user, :id, :user_id, :user_type, :active
  json.extract! group_user.user, :name, :image

    json.groups_count group_user.user.user_groups.active.where(blocked: false).includes(:group).where.not(groups: {privacy: 2}).count

    json.current_user_groups_count     json.groups_count group_user.user.user_groups.active.where(blocked: false).count

  json.polls_count 0
  json.votes_count 0
   end
end
json.requests @group_users.inactive do |group_user|
  json.extract! group_user, :id, :user_id, :user_type, :active
  json.extract! group_user.user, :name, :image
    json.users_count group_user.user.user_groups.active.where(blocked: false).includes(:group).where.not(groups: {privacy: 2}).count
      json.votes_count 0
end
