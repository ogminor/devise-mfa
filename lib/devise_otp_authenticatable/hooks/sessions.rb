module DeviseOtpAuthenticatable::Hooks
  module Sessions
    extend ActiveSupport::Concern
    include DeviseOtpAuthenticatable::Controllers::UrlHelpers

    private
      # resource should be challenged for otp
      def otp_challenge_required_on?(resource)
        return false unless resource.respond_to?(:otp_enabled) and resource.respond_to?(:otp_auth_secret)
        resource.otp_enabled and !is_otp_trusted_device_for?(resource)
      end

      # the resource -should- have otp turned on, but it isn't
      def otp_mandatory_on?(resource)
        return true if resource.class.otp_mandatory
        return false unless resource.respond_to?(:otp_mandatory)
        resource.otp_mandatory and !resource.otp_enabled
      end
  end
end
