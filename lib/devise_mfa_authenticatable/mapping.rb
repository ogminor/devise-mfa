module DeviseMfaAuthenticatable
  module Mapping

    def self.included(base)
      base.alias_method_chain :default_controllers, :mfa
    end

    private
      def default_controllers_with_mfa(options)
        options[:controllers] ||= {}
        options[:controllers][:mfa_tokens]      ||= "tokens"
        options[:controllers][:mfa_credentials] ||= "credentials"
        default_controllers_without_mfa(options)
      end
  end
end
