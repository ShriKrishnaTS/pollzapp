class VotesController < ApplicationController
  include Authenticate

  def vote
    poll = Poll.find params[:poll_id]
    if @current_user.groups.include?(poll.group) && !@current_user.user_groups.find_by_group_id(poll.group_id).blocked
      @vote = Vote.new user: @current_user, poll_id: params[:poll_id], choice: params[:choice]
      if @vote.save
        total = @vote.poll.votes.count
        option_1_count = @vote.poll.votes.where(choice: @vote.poll.option_1).count
        users_count = @vote.poll.group.group_users.where.not(id: @current_user.id).count
        @option_1_result = total > 0 ? option_1_count*100/total : 0
        @option_2_result = total > 0 ? (total - option_1_count)*100/total : 0
        render json: {message: 'Vote recorded'}
      else
        render json: @vote.errors.full_messages, status: :unprocessable_entity
      end
    else
      render json: {error: 'Sorry, You must join the group before you can vote'}, status: :unprocessable_entity
    end
  end
end