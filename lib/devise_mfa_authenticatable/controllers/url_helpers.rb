module DeviseMfaAuthenticatable
  module Controllers
    module UrlHelpers

      def refresh_mfa_credential_path_for(resource_or_scope, opts = {})
        scope = Devise::Mapping.find_scope!(resource_or_scope)
        send("validate_#{scope}_mfa_credential_path", opts)
      end

      def mfa_token_path_for(resource_or_scope, opts = {})
        scope = Devise::Mapping.find_scope!(resource_or_scope)
        send("#{scope}_mfa_token_path", opts)
      end

    end
  end
end
