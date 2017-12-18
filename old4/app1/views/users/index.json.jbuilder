json.array! @users do |user|
  json.extract! user, :id, :name, :username
  json.thumbnail user.image.thumbnail.url

  json.groups_count user.user_groups.active.where(blocked: false).includes(:group).where.not(groups: {privacy: 2}).count
  json.votes_count user.votes.count
end