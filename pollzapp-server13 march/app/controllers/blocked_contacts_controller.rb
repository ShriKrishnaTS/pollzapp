class BlockedContactsController < ApplicationController
  include Authenticate

  def index
    @contacts = @current_user.user_contacts.blocked
  end

  def create
    @contact = @current_user.user_contacts.where(contact_id: params[:user_id]).first_or_create
    @contact.update(blocked: true)
  end
end
