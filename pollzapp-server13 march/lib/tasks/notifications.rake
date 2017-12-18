namespace :notifications do
  desc "Push pending notifications for all users"
  task push: :environment do
    app = RailsPushNotifications::GCMApp.first
    Notification.where(pushed: false).each do |n|
      if n.user.notifications_enabled
        notification = app.notifications.create(
            destinations: n.user.devices.where(os: 'Android').map(&:push_token),
            data: {message: n.text, link: n.link, user_id: n.user_id, group_id: n.group_id, poll_id: n.poll_id, code: n.code, title: 'pollzapp', image: n.icon.url}
        )
      end
      n.update pushed:  true
    end
    app.push_notifications
  end
  task ended: :environment do
    Poll.where(end_msg_sent: false).where(['ends_on < ?', DateTime.now]).each do |p|
      p.group.group_users.active.unblocked.each do |gu|
        u = gu.user
        # unless u.id == p.user_id
          poll = {
              user: {}, group: {}, id: p.id, result: {}, comments: [], image: {}, image_1: {}, image_2: {}
          }
          mute_till = u.user_groups.find_by_group_id(p.group_id).mute_till
          if !mute_till || mute_till < Time.now
            n = Notification.create user_id: u.id, group_id: p.group.id, poll_id: p.id,
               name:p.user.name, 
          username:p.user.username, 
          image:p.group.image.url, 
          user_image:p.user.image.url, 
          poll_title:p.title, 
          group_title:p.group.name,
          creator_id:p.user.id,
          description:'[POLLTITLE] has ended!',
          code: '114',
          link: 'pages/poll/screen', text: p.title + ' has ended!', parts: [
                
                {poll_id: p.id, link: 'pages/poll/screen', context: nil},
                {group_id: p.group.id, link: nil, context: nil},
                {name: p.user.name, link: nil, context: {id: p.user_id}},
                {username: p.user.username, link: nil, context: {id: p.user_id}},
                {user_image: p.user.image.thumbnail.url, link: nil, context: {id: p.user_id}},
                {descriptioin: 'has ended! ', link: nil, context: nil},
                {poll_title: "#{p.title.upcase!}", link: 'pages/poll/screen', context: {poll: poll}},
                {group_image: p.group.image.thumbnail.url, link: nil, context: {group: {id: p.group_id}}},
                {group_name: p.group.name, link: nil, context: {group: {id: p.group_id}}},
                
            ], icon: p.composite

          end
        # end

        p.update end_msg_sent: true
      end
    end
  end
  task not_voted: :environment do
    app = RailsPushNotifications::GCMApp.first
    Poll.where(not_voted: false).where('(((UNIX_TIMESTAMP(ends_on)-UNIX_TIMESTAMP(created_at))/2) < (UNIX_TIMESTAMP()-UNIX_TIMESTAMP(created_at)) AND (UNIX_TIMESTAMP(ends_on)) > (UNIX_TIMESTAMP())AND duration > 4)').each do |p|
     p.group.group_users.active.unblocked.each do |gu|
        u = gu.user
        unless u.id == p.user_id
          poll = {
              user: {}, group: {}, id: p.id, result: {}, comments: [], image: {}, image_1: {}, image_2: {}
          }
         #  mute_till = u.user_groups.find_by_group_id(p.group_id).mute_till
         #  if !mute_till || mute_till < Time.now
           
         # sql = "(SELECT id from polls where ((UNIX_TIMESTAMP(ends_on)-UNIX_TIMESTAMP(created_at))/2) < (UNIX_TIMESTAMP(NOW())-UNIX_TIMESTAMP(created_at)) AND (UNIX_TIMESTAMP(ends_on)) > (UNIX_TIMESTAMP(NOW())))"
            # duration = ((Time.parse(p.ends_on.to_s)) - (Time.parse(p.created_at.to_s)))/3600
            # half_duration = duration/2
            # time_diff_with_start_time = (Time.parse(DateTime.now.to_s) - Time.parse(p.created_at.to_s))
            # if half_duration == time_diff_with_start_time
                     # records_array = ActiveRecord::Base.connection.execute(sql)
             n = Notification.create user_id: u.id, group_id: p.group.id, poll_id: p.id,
               name:p.user.name, 
          username:p.user.username, 
          image:p.group.image.url, 
          user_image:p.user.image.url, 
          poll_title:p.title, 
          group_title:p.group.name,
          creator_id:p.user.id,
          code: '112',
          description:"You haven't voted in [POLLTITLE] ", 
          link: 'pages/poll/screen', text: 'You have not voted in ' + p.title, parts: [
                {poll_id: p.id, link: 'pages/poll/screen', context: nil},
                {group_id: p.group.id, link: nil, context: nil},
                {name: p.user.name, link: nil, context: {id: p.user_id}},
                {username: p.user.username, link: nil, context: {id: p.user_id}},
                {user_image: p.user.image.thumbnail.url, link: nil, context: {id: p.user_id}},
                {desciption: 'You have not voted in ', link: nil, context: nil},
                {poll_title: "#{p.title.upcase!}", link: 'pages/poll/screen', context: {poll: poll}},
                {poll_image: p.group.image.thumbnail.url, link: nil, context: {group: {id: p.group_id}}},
                {group_name: p.group.name, link: nil, context: {group: {id: p.group_id}}},
              ], icon: p.composite
            end
          # end 
         #  end
          p.update not_voted: true
        end
      end
    end
   task before_an_hour: :environment do
    Poll.where(before_an_hour_msg_sent: false).where('((UNIX_TIMESTAMP(ends_on)>UNIX_TIMESTAMP()) AND ((UNIX_TIMESTAMP(ends_on)>UNIX_TIMESTAMP())<3600)AND((UNIX_TIMESTAMP(ends_on)-UNIX_TIMESTAMP())>3500)AND((UNIX_TIMESTAMP(ends_on)-UNIX_TIMESTAMP())<3600)AND duration > 0)').each do |p|
     p.group.group_users.active.unblocked.each do |gu|
        u = gu.user
        unless u.id == p.user_id
          poll = {
              user: {}, group: {}, id: p.id, result: {}, comments: [], image: {}, image_1: {}, image_2: {}
          }
          # mute_till = u.user_groups.find_by_group_id(p.group_id).mute_till
          # if !mute_till || mute_till < Time.now
          
            # time_diff_with_start_time = (((Time.parse(p.ends_on.to_s))-(Time.parse(DateTime.now.to_s)))/1.hour).round
            # if time_diff_with_start_time == 1
              n = Notification.create user_id: u.id,  group_id: p.group.id, poll_id: p.id,
               name:p.user.name, 
          username:p.user.username, 
          image:p.group.image.url, 
          user_image:p.user.image.url, 
          poll_title:p.title, 
          group_title:p.group.name,
          creator_id:p.user.id,
          description:'1 hour left to vote in [POLLTITLE]',
          code: '113',
          link: 'pages/poll/screen',text: '1 hour left to vote in ' + p.title, parts: [
                {text: p.user.name, link: nil, context: nil},
                {text: p.user.username, link: nil, context: nil},
                {text: p.user.image.thumbnail.url, link: nil, context: nil},
                {text: ' 1 hour left to vote ', link: nil, context: nil},
                {text: p.title, link: 'pages/poll/screen', context: {poll: poll}},
                {text: p.group.image.thumbnail.url, link: nil, context: {group: {id: p.group_id}}},
                {text: p.group.name, link: nil, context: {group: {id: p.group_id}}},
                {text: ' 1 hour left to vote in  ' + p.title, link: 'pages/poll/screen', context: {poll: poll}},
              ], icon: p.composite
            end
          end
       
           # p.update before_an_hour_msg_sent: true
          # end
   end
 end
end