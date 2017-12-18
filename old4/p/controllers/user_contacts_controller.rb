class UserContactsController < ApplicationController
  include Authenticate
  before_action :set_user_contact, only: [:show, :update, :destroy]

  # GET /user_contacts
  # GET /user_contacts.json
  def index
    @user_contacts = @current_user.user_contacts.order(name: 'ASC').paginate(:page => params[:page], :per_page => 25)
    @pollzapp_contacts = @user_contacts.select { |c| c.contact.present? }
    @other_contacts = @user_contacts.reject { |c| c.contact.present?} 
  end

  # GET /user_contacts/1
  # GET /user_contacts/1.json
  def show
  end

  # POST /user_contacts
  # POST /user_contacts.json
  def create
    @user_contact = @current_user.user_contacts.new(user_contact_params)
    if @user_contact.save
      render :show, status: :created, location: @user_contact
    else
      render json: @user_contact.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /user_contacts/1
  # PATCH/PUT /user_contacts/1.json
  def update
    if @user_contact.update(user_contact_params)
      render :show, status: :ok, location: @user_contact
    else
      render json: @user_contact.errors, status: :unprocessable_entity
    end
  end

  # DELETE /user_contacts/1
  # DELETE /user_contacts/1.json
  def destroy
    @user_contact.destroy
    render json: {message: 'Contact deleted successfully'}
  end


def sync
params[:contacts].each do |u| 
 
 
      unless u[:phone] == @current_user.phone
        user = User.find_by_phone u[:phone]
        if user
          @current_user.user_contacts.where(contact_id: user.id).first_or_create
        else
          @current_user.user_contacts.where(name: u[:name], phone: u[:phone]).first_or_create
        end
      end
    end
    render json: {message: 'Contacts synced'}
  end
  # Use callbacks to share common setup or constraints between actions.
  def set_user_contact
    @user_contact = @current_user.user_contacts.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_contact_params
    params.permit(:contact_id, :blocked)
  end
end
