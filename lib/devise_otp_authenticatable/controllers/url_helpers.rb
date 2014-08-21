module DeviseOtpAuthenticatable
  module Controllers
    module UrlHelpers

      def refresh_otp_credential_path_for(resource_or_scope, opts = {})
        scope = Devise::Mapping.find_scope!(resource_or_scope)
        send("validate_#{scope}_otp_credential_path", opts)
      end

      def otp_token_path_for(resource_or_scope, opts = {})
        scope = Devise::Mapping.find_scope!(resource_or_scope)
        send("#{scope}_otp_token_path", opts)
      end

    end
  end
end
