class NotificationsController < ApplicationController
  include Authenticate

  def index
    @notifications = @current_user.notifications.order(created_at: :desc).limit 500
  end

  def read
    @current_user.notifications.where(read: false).update_all read: true
    render json: {message: 'Notifications marked as read'}
  end

  def destroy
       @current_user.notifications.where(id: params[:id].split(',')).delete_all

    render json: {message: 'Notification deleted successfully'}
  end
end
