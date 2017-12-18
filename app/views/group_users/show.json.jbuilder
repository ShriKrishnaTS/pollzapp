json.id @group_user.id
json.user_id @group_user.user_id
json.status @group_user.active
json.user_type @group_user.user_type
json.name @group_user.user.name
json.name @group_user.user.username

json.image @group_user.user.image
json.groups_count @group_user.user.groups.count
json.polls_count 0
json.votes_count 0