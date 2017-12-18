json.array! @users do |user|
  json.extract! user, :id, :name, :username, :phone
  json.thumbnail user.image.thumbnail.url

  json.groups_count user.user_groups.active.where(blocked: false).includes(:group).where.not(groups: {privacy: 2} && {deleted: 1}).count
  json.votes_count user.votes.count
end
