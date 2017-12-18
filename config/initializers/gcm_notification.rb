module RubyPushNotifications
  module GCM
    class GCMNotification
      def as_gcm_json
        JSON.dump(
            registration_ids: @registration_ids,
            data: @data,
            collapse_key: 'pollzapp',
            tag: 'pollzapp'
        )
      end
    end
  end
end