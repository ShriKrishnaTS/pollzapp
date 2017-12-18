class OtpController < ApplicationController
  # POST /otp
  # POST /otp.json
  require 'sinch_sms'
  def create
    unless params[:phone].present?
      return render json: {error: 'Phone number is required'}, status: 422
    end
    phone_number = params["phone"]
    @user = User.where(phone: params[:phone]).first_or_create
    logger.info @user.errors.full_messages
    if params[:push_token] && params[:os]
      @user.devices.where(push_token: params[:push_token], os: params[:os]).first_or_create
    end
    unless @user.persisted?
      render json: @user.errors.full_messages, status: 422
    end
    #puts "#{@user.otp_code}"
#    SinchSms.send('dadc5654-0462-49ca-a597-87fb791447d0', 'F18Hou5MjkWQ/EkFVqDqIA==', "Hello", phone_number)
end


  # PATCH/PUT /otp/1
  # PATCH/PUT /otp/1.json
  def update
    unless params[:phone].present? && params[:otp]
      return render json: {error: 'Phone number is required'}, status: 422
    end
    user = User.find_by_phone params[:phone]
    if user.authenticate_otp(params[:otp], drift: 120)
      render json: {message: 'OTP Verified', auth_token: user.auth_token}
    else
      render json: {error: 'Invalid OTP'}, status: 422
    end
  end
end
