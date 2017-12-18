class BroadcastMessagesController < ApplicationController
              layout "dashboard"

	def index
  n = Notification.create user_id: User.all,
                                  
                                    description:' Text ',
                                    link: 'nil',
                                    code: '1100',
                                    text: ' Text ',
                                    parts: [
                                        {description: ' Text ', link: nil, context: nil},
                                       ]	end

	
end
