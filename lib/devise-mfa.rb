require "devise-mfa/version"
require 'devise'

module Devise
  mattr_accessor :mfa_mandatory
  @@mfa_mandatory = false

  mattr_accessor :mfa_authentication_timeout
  @@mfa_authentication_timeout = 3.minutes

  mattr_accessor :mfa_recovery_tokens
  @@mfa_recovery_tokens = 10  ## false to disable

  mattr_accessor :mfa_drift_window
  @@mfa_drift_window = 3 # in minutes

  mattr_accessor :mfa_credentials_refresh
  @@mfa_credentials_refresh = 15.minutes  # or like 15.minutes, false to disable

  mattr_accessor :mfa_uri_application
  @@mfa_uri_application = Rails.application.class.parent_name
  
  mattr_accessor :mfa_return_path
  @@mfa_return_path = "root"
end

module DeviseMfaAuthenticatable
  autoload :Mapping, 'devise_mfa_authenticatable/mapping'
  module Controllers
    autoload :Helpers,    'devise_mfa_authenticatable/controllers/helpers'
    autoload :UrlHelpers, 'devise_mfa_authenticatable/controllers/url_helpers'
  end
end

require 'devise_mfa_authenticatable/routes'
require 'devise_mfa_authenticatable/engine'

Devise.add_module :mfa_authenticatable,
                  :controller => :mfa_tokens,
                  :model => 'devise_mfa_authenticatable/models/mfa_authenticatable', :route => :mfa
