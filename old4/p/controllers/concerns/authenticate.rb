module Authenticate
  extend ActiveSupport::Concern

  included do
    before_action do
      authenticate_or_request_with_http_token do |token, options|
        @current_user = User.find_by_auth_token token
      end
    end
  end

  def request_http_token_authentication(realm = "Application", dummy)
    self.headers["WWW-Authenticate"] = %(Token realm="#{realm.gsub(/"/, "")}")
    render :json => {:error => "HTTP Token: Access denied."}, :status => :unauthorized
  end
end
