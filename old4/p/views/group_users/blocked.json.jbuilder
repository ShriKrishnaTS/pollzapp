json.array! @group_users.active do |group_user|
  json.extract! group_user, :id, :user_id, :user_type, :active
  json.extract! group_user.user, :name, :image, :username
   json.groups_count group_user.user.user_groups.active.where(blocked: false).includes(:group).where.not(groups: {privacy: 2}).count
  json.polls_count group_user.user.polls.count
  json.votes_count group_user.user.votes.count
end
