class SearchController < ApplicationController
  include Authenticate
  def index
    q = params[:q]
    @all_polls = Poll.joins('LEFT OUTER JOIN `polls_tags` ON `polls_tags`.`poll_id` = `polls`.`id` LEFT OUTER JOIN `tags` ON `tags`.`id` = `polls_tags`.`tag_id` JOIN groups ON polls.group_id = groups.id JOIN group_users ON group_users.group_id = groups.id')
                 .where("tags.name LIKE ? OR polls.title LIKE ? OR polls.title LIKE ?", "#{q}", "#{q}%", "% #{q}%")
                 .where('(groups.privacy = 0 OR groups.privacy = 1 OR (groups.privacy = 2 AND group_users.user_id = ?)) OR (group_users.id = ? AND group_users.blocked = 0 AND group_users.active = 1)',@current_user.id, @current_user.id).uniq.order(updated_at: :desc)
    @private_polls = Poll.joins('LEFT OUTER JOIN `polls_tags` ON `polls_tags`.`poll_id` = `polls`.`id` LEFT OUTER JOIN `tags` ON `tags`.`id` = `polls_tags`.`tag_id` JOIN groups ON polls.group_id = groups.id JOIN group_users ON group_users.group_id = groups.id')
                 .where("group_users.user_id = ?", @current_user.id).where("groups.privacy = 2").where("tags.name LIKE ? OR polls.title LIKE ? OR polls.title LIKE ?", "#{q}", "#{q}%", "% #{q}%").uniq.order(updated_at: :desc)
    @polls = @all_polls 
    if ("#{params[:q]}".length > 3)
    @contacts = @current_user.contacts.where("users.name LIKE ? OR users.name LIKE ?", "#{params[:q]}%", "% #{params[:q]}%")
    @others = User.where("username LIKE ? OR username LIKE ?", "#{params[:q]}%", "% #{params[:q]}%").where.not(id: @contacts.map(&:id))
    @people = @contacts + @others
  end
    @all_groups = GroupUser.joins(:group).where('name LIKE ? OR name LIKE ?', "#{q}%", "% #{q}%").where('(groups.privacy = 0 OR groups.privacy = 1 OR (groups.privacy = 2 AND group_users.user_id = ?)) OR (group_users.id = ? AND group_users.blocked = 0 AND group_users.active = 1)', @current_user.id, @current_user.id).uniq.order(updated_at: :desc).map(&:group).uniq
    #(privacy: ['Public', 'Closed']).where('name LIKE ? OR name LIKE ?', "#{q}%", "% #{q}%").order(updated_at: :desc).map(&:group)
  #  @private_groups = GroupUser.joins(:group).where("group_users.user_id = ?", @current_user.id).where("groups.privacy = 2").where('name LIKE ? OR name LIKE ?', "#{q}%", "% #{q}%").order(updated_at: :desc).map(&:group)
    @groups = @all_groups #+ @private_groups  
  end
end