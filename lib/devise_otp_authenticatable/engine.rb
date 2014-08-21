module DeviseOtpAuthenticatable
  class Engine < ::Rails::Engine

    ActiveSupport.on_load(:action_controller) do
      include DeviseOtpAuthenticatable::Controllers::UrlHelpers
      include DeviseOtpAuthenticatable::Controllers::Helpers
    end
    ActiveSupport.on_load(:action_view) do
      include DeviseOtpAuthenticatable::Controllers::UrlHelpers
      include DeviseOtpAuthenticatable::Controllers::Helpers
    end

    config.after_initialize do
      Devise::Mapping.send :include, DeviseOtpAuthenticatable::Mapping
    end
  end
end
