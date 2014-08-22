module DeviseMfaAuthenticatable
  class Engine < ::Rails::Engine

    ActiveSupport.on_load(:action_controller) do
      include DeviseMfaAuthenticatable::Controllers::Helpers
    end
    ActiveSupport.on_load(:action_view) do
      include DeviseMfaAuthenticatable::Controllers::Helpers
    end

    config.after_initialize do
      Devise::Mapping.send :include, DeviseMfaAuthenticatable::Mapping
    end
  end
end
