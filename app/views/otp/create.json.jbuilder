json.extract! @user, :id, :name, :username, :phone, :disabled
json.message 'OTP Sent'
json.otp "#{@user.otp_code}"

