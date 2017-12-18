require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Pollzapp
  class Application < Rails::Application
    config.generators do |g|
      g.test_framework false
      g.stylesheets = false
      g.javascripts = false
      g.template_engine = :jbuilder
    end
    
    config.middleware.use 'Rack::RawUpload', :explicit => true

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*', :headers => :any, :methods => :any
      end
    end
  end
end
