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
    unless @user.persisted?
      render json: @user.errors.full_messages, status: 422
    end
      if (params["phone"] == '+919742372862')
        puts "#{@user.otp_code}"
      else
	SinchSms.send('9392d9b1-5aab-4612-8bfa-9cba6a8ee7f2', '+C4TNkTHUkmiBawWsobfCA==', "Your pollzapp code is #{@user.otp_code}", phone_number)
      end
   end


  # PATCH/PUT /otp/1
  # PATCH/PUT /otp/1.json
  def update
    unless params[:phone].present? && params[:otp]
      return render json: {error: 'Phone number is required'}, status: 422
    end
    user = User.find_by_phone params[:phone]
    @user = User.where(phone: params[:phone]).first_or_create
    if user.authenticate_otp(params[:otp], drift: 120)
    if params[:push_token] && params[:os]
      @user.devices.where(push_token: params[:push_token], os: params[:os]).first_or_create
    end

      render json: {message: 'OTP Verified', auth_token: user.auth_token}
    else
      render json: {error: 'Invalid OTP'}, status: 422
    end
  end
  # DELETE /logout?user_id=1
  def logout
    @user = Device.find_by_push_token params[:push_token]
    @user.destroy.push_token
    @user.save
    render json: {message: 'Push token deleted'}
  end
end
