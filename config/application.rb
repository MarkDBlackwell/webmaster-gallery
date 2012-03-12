load File.expand_path '../../monkey_patch_mongrel_1.1.5/constants.rb',
    __FILE__ unless defined? GUARD_MONKEY_PATCH_CONSTANTS

p Time.now, 'in '+__FILE__ unless STARTED_BY_TEST

require File.expand_path('../boot', __FILE__)

## require 'rails/all'
# Removed 'action_mailer' from the list:

%w[action_controller active_record active_resource rails/test_unit].each {|e|
    require "#{e}/railtie"}

if STARTED_BY_TEST

## BUNDLER
## If you have a Gemfile, require the gems listed there, including any gems
## you've limited to :test, :development, or :production.
## Bundler.require(:default, Rails.env) if defined?(Bundler)

  Bundler.require(:default, :server, Rails.env) if defined?(Bundler)

end

module Gallery
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # JavaScript files you want as :defaults (application.js is always included).
    # config.action_view.javascript_expansions[:defaults] = %w(jquery rails)

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

# Does not work (does not restrict to just these tags):
##    config.action_view.sanitized_allowed_tags = %w[ br ]

# (wrong # of args) config.action_controller.relative_url_root = '/webmas-gallery'
# (caching didn't happen) env RAILS_RELATIVE_URL_ROOT="/webmas-gallery" rails server
# (webmas-gallery/javascripts/rails.js not found) config.relative_url_root = '/webmas-gallery'

# A double slash was created when infixing a slash, e.g.:
##    proc {|p| "assets/#{p}"}  as per
#  http://guides.rubyonrails.org/configuring.html.

# Without the '.action_controller' part, nothing happened as of Rails 3.0.3:
##    config.asset_path = proc{ |p| "/webmas-gallery#{p}" }
    config.action_controller.asset_path = proc{|p| "/webmas-gallery#{p}"}

# On deployment machine, make this symlink:
#  ln -s $HOME/rails_apps/webmas-gallery $HOME/public_html/webmas-gallery


# Ref:
# How Homakov hacked GitHub and how to protect your application by Peter Nixey - Gist:
# https://gist.github.com/1978249
# http://guides.rubyonrails.org/security.html#mass-assignment

    config.active_record.whitelist_attributes = true

  end
end
