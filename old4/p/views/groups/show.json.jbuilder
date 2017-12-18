json.extract! @group, :id, :name, :description, :privacy, :admins_can_add_users, :share_id, :members_can_create_polls
json.share_id_active @group ? @group.share_id  : nil
json.group_user_id @group_user ? @group_user.id : nil
json.user_type @user_type
json.user_active @group_user ? @group_user.active && !@group_user.blocked : false
json.users_count @group.group_users.active.where(blocked: false).count
json.polls_count @group.polls.count
json.votes_count @group.votes.count
json.thumbnail @group.image.thumbnail.url

json.requests @group.group_users.inactive do |gu|
  json.id gu.id
  json.user_id gu.user_id
  json.name gu.user.name
  json.username gu.user.username  
  json.user_type gu.user_type
  json.thumbnail gu.user.image.thumbnail.url
  json.groups_count gu.user.user_groups.active.where(blocked: false).includes(:group).where.not(groups: {privacy: 2}).count
  json.polls_count gu.user.polls.count
  json.votes_count gu.user.votes.count
end

json.users @group.group_users.active.where(blocked: false).reverse do |gu|
  json.id gu.id
  json.user_id gu.user_id
  json.name @current_user.id == gu.user_id ? 'You' : gu.user.name
  json.username gu.user.username
  json.phone gu.user.phone
  json.user_type gu.user_type
  json.thumbnail gu.user.image.thumbnail.url
 json.groups_count gu.user.user_groups.active.where(blocked: false).includes(:group).where.not(groups: {privacy: 2}).count
 json.private_groups_count gu.user.user_groups.active.where(blocked: false).includes(:group).where(groups:{privacy:2}).count
  json.polls_count gu.user.polls.count
  json.votes_count gu.user.votes.count
end