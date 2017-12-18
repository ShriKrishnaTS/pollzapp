class ShareController < ApplicationController
	around_filter :catch_not_found

  def join_group
     @group = Group.find_by!(share_id: params[:share_id])
    render "shares/join"
  end

private

def catch_not_found
  yield
rescue ActiveRecord::RecordNotFound
  render "shares/index"
end
end