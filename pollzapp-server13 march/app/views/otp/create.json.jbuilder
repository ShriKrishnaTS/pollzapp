json.message 'OTP Sent'
 phone_number = params["phone"]
    SinchSms.send('9392d9b1-5aab-4612-8bfa-9cba6a8ee7f2', '+C4TNkTHUkmiBawWsobfCA==', "Hi, Your otp to register for Pollzapp is #{@user.otp_code}", phone_number)

