namespace :notifications do
  desc "Push pending notifications for all users"
  task push: :environment do
    app = RailsPushNotifications::GCMApp.first
    Notification.where(pushed: false).each do |n|
      if n.user.notifications_enabled
        notification = app.notifications.create(
            destinations: n.user.devices.where(os: 'Android').map(&:push_token),
            data: {message: n.text, link: n.link, user_id: n.user_id, group_id: n.group_id, poll_id: n.poll_id, creator_id: n.creator_id, group_title: n.group_title, code: n.code, title: 'pollzapp', image: n.icon.url}
        )
      end
      n.update pushed:  true
    end
    app.push_notifications
  end
 task pushios: :environment do
   iosapp = FCM.new("AAAARsMXXx8:APA91bH_ylxG083jHnqYQb7HPd-i_9dJbMwn7kRsk9HII7qNy0f7TtbadMxO5I3zEjh7OybGu1KtQanJncyVK1Swlr9IDXXyARucgBk9ay4tvLFYaTY5wgftwYHUUGrQ0UeBVTZaVISERvNxKoTxVqP9OAVAjRzi8g")
   Notification.where(pushed: false).each do |n|
      if n.user.notifications_enabled
        notification_tokens = n.user.devices.where(os: 'ios').map(&:push_token)
         options = {
          priority: "high",
          collapse_key: "updated_score", 
          notification: {
              title: "POLLZAPP", 
              body: n.text.to_s,
              icon: "myicon"},
             data: {message: n.text, link: n.link, user_id: n  .user_id, group_id: n.group_id, poll_id: n.poll_id, creator_id: n.creator_id,group_title: n.group_title, code: n.code, title: 'pollzapp', image: n.icon.url}
          }
            
          notification_tokens.each do |n|
            token = n.split(',')
            print token.instance_of? Array
            print token
            resp = iosapp.send(token, options)
            print resp

          end  
          # n.update pushed:  true
          # data: {message: n.text, link: n.link, user_id: n  .user_id, group_id: n.group_id, poll_id: n.poll_id, creator_id: n.creator_id, code: n.code, title: 'pollzapp', image: n.icon.url}
      end
    end
  end
	
    task ended: :environment do
    Poll.where(end_msg_sent: false).where(['ends_on < ?', DateTime.now]).each do |p|
      p.group.group_users.active.unblocked.each do |gu|
        u = gu.user
        # unless u.id == p.user_id
        poll = {
            user: {}, group: {}, id: p.id, result: {}, comments: [], image: {}, image_1: {}, image_2: {}
        }
      #  mute_till = u.user_groups.find_by_group_id(p.group_id).mute_till
       # if !mute_till || mute_till < Time.now

          n = Notification.create user_id: u.id, group_id: p.group.id, poll_id: p.id,
                                  name: 'pollzapp',
                                  username: 'pollzapp',
                                  image:p.group.image.url,

                                  poll_title:p.title,
                                  group_title:p.group.name,
                                  creator_id:1,
                                  description:'[POLLTITLE] has ended!',
                                  code: '114',
                                  link: 'pages/poll/screen', text: "#{p.title.upcase}" + ' has ended!', parts: [
                  {poll_id: p.id, link: 'pages/poll/screen', context: nil},
                  {group_id: p.group.id, link: nil, context: nil},
                  {name: 'pollzapp', link: nil, context: {id: 1}},
                  {username: 'pollzapp', link: nil, context: {id: p.user_id}},
                  #{user_image: p.user.image.thumbnail.url, link: nil, context: {id: p.user_id}},
                  {descriptioin: 'has ended! ', link: nil, context: nil},
                  {poll_title: "#{p.title.upcase!}", link: 'pages/poll/screen', context: {poll: poll}},
                  {group_image: p.group.image.thumbnail.url, link: nil, context: {group: {id: p.group_id}}},
                  {group_name: p.group.name, link: nil, context: {group: {id: p.group_id}}},

              ], icon: p.composite

          # end


        p.update end_msg_sent: true
      end
    end
  end


  task not_voted: :environment do
    Poll.where(not_voted: false).each do |p|
      p.group.group_users.active.unblocked.each do |gu|
        u = gu.user
        # unless u.id == p.user_id
        poll = {
            user: {}, group: {}, id: p.id, result: {}, comments: [], image: {}, image_1: {}, image_2: {}
        }



        sqlquery = "SELECT devices.user_id, devices.push_token,
                                    not_voted_notifier.id, not_voted_notifier.poll_title, not_voted_notifier.image
                                    from devices INNER JOIN not_voted_notifier ON
                                    devices.user_id = not_voted_notifier.user_id"
        records_array = ActiveRecord::Base.connection.execute(sqlquery)
        print records_array
        records_array.each do |r|
          puts r
          Poll.where(:id => r[2]).update(:not_voted => 1)

          n =Notification.create! user_id: r[0], text: "You haven't voted in [POLLTITLE]", poll_id: r[2], poll_title: r[3],image: r[4],                             text: "You haven't voted in "+ "#{r[3].upcase!}",
                                  description:"You haven't voted in [POLLTITLE]",
                                  code: '112',
                                  link: 'pages/poll/screen', parts: [
                  {description: " You haven't voted in ", link: nil, context: nil},]

        end


        #Poll.update not_voted: true
      end
    end
  end

task before_an_hour: :environment do      

         sqlquery = "SELECT devices.user_id, devices.push_token, getnotify.id, getnotify.poll_title,getnotify.image from devices INNER JOIN getnotify ON devices.user_id = getnotify.user_id"
                records_array = ActiveRecord::Base.connection.execute(sqlquery)
                print records_array
                records_array.each do |r|  
                    puts r
          
                  n = Notification.create! user_id: r[0], text: '1 hour left to vote in [POLLTITLE]', poll_id: r[2], poll_title: r[3], image: r[4],
                  # name:p.user.name,
                  # username:p.user.username,
                  # image:p.group.image.url,
                  # user_image:p.user.image.url,
                  # poll_title:getnotify.poll_title,
                  # group_title:p.group.name,
                  # creator_id:p.user.id,
                  text:'1 hour left to vote in '+ "#{r[3].upcase!}",
                  description:'1 hour left to vote in [POLLTITLE]',
                  code: '113',
                  link: 'pages/poll/screen', parts: [
                        # {text: p.user.name, link: nil, context: nil},
                        # {text: p.user.username, link: nil, context: nil},
                        # {text: p.user.image.thumbnail.url, link: nil, context: nil},
                        {description: '1 hour left to vote ', link: nil, context: nil},
                        # {text: records_array, link: 'pages/poll/screen', context: nil},
                        # {text: p.group.image.thumbnail.url, link: nil, context: {group: {id: p.group_id}}},
                        # {text: p.group.name, link: nil, context: {group: {id: p.group_id}}},
                       # {text: ' 1 hour left to vote in  ' + records_array, link: 'pages/poll/screen', context: {poll: poll}},
                      ]
            
            puts n
         end

           # p.update before_an_hour_msg_sent: true
          # end
   
 end
end
