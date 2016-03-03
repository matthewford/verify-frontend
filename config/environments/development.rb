Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Asset digests allow you to set far-future HTTP expiration dates on all assets,
  # yet still be able to expire them through the digest params.
  config.assets.digest = true

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  #Cookie Configuration
  config.x.cookies.secure = false

  #####################
  ## Logstash config ##
  #####################

  # Enable the logstasher logs for the current environment

  config.logstasher.enabled = true
  config.logstasher.logger = Logger.new("#{Rails.root}/log/logstasher.log")

  # Each of the following lines are optional. If you want to selectively disable log subscribers.
  # config.logstasher.controller_enabled = false
  # config.logstasher.mailer_enabled = false
  # config.logstasher.record_enabled = false
  # config.logstasher.view_enabled = false

  config.logstasher.log_level = :error

  # This line is optional if you do not want to suppress app logs in your <environment>.log
  config.logstasher.suppress_app_log = true

  # This line is optional, it allows you to set a custom value for the @source field of the log event
  #config.logstasher.source = 'your.arbitrary.source'

  # This line is optional if you do not want to log the backtrace of exceptions
  # config.logstasher.backtrace = false

  # This line is optional, defaults to log/logstasher_<environment>.log
  # config.logstasher.logger_path = 'log/logstasher.log'
end
