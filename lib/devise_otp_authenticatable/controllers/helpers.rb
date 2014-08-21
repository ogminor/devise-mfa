module DeviseOtpAuthenticatable
  module Controllers
    module Helpers

      def authenticate_scope!
        send(:"authenticate_#{resource_name}!", :force => true)
        self.resource = send("current_#{resource_name}")
      end

      # similar to DeviseController#set_flash_message, but sets the scope inside
      # the otp controller
      def otp_set_flash_message(key, kind, options={})
        options[:scope] ||= "devise.otp.#{controller_name}"
        options[:default] = Array(options[:default]).unshift(kind.to_sym)
        options[:resource_name] = resource_name
        options = devise_i18n_options(options) if respond_to?(:devise_i18n_options, true)
        message = I18n.t("#{options[:resource_name]}.#{kind}", options)
        flash[key] = message if message.present?
      end

      def recovery_enabled?
        resource.class.otp_recovery_tokens && (resource.class.otp_recovery_tokens > 0)
      end

      #
      # Sanity check for resource validity
      #
      def ensure_resource!
        if resource.nil?
          raise ArgumentError, "Should not happen"
        end
      end

      # check if the resource needs a credentials refresh. IE, they need to be asked a password again to access
      # this resource.
      def needs_credentials_refresh?(resource)
        return false unless resource.class.otp_credentials_refresh

        (!session[otp_scoped_refresh_property].present? ||
            (session[otp_scoped_refresh_property] < DateTime.now)).tap { |need| otp_set_refresh_return_url if need }
      end

      # credentials are refreshed
      def otp_refresh_credentials_for(resource)
        return false unless resource.class.otp_credentials_refresh
        session[otp_scoped_refresh_property] = (Time.now + resource.class.otp_credentials_refresh)
      end

      def otp_set_refresh_return_url
        session[otp_scoped_refresh_return_url_property] = request.fullpath
      end

      def otp_fetch_refresh_return_url
        session.delete(otp_scoped_refresh_return_url_property) { resource.class.otp_return_path.to_sym }
      end

      def otp_scoped_refresh_return_url_property
        "otp_#{resource_name}refresh_return_url".to_sym
      end

      def otp_scoped_refresh_property
        "otp_#{resource_name}refresh_after".to_sym
      end

      # To be removed, this can be handled in the application 
      def otp_authenticator_token_image(resource)
        otp_authenticator_token_image_google(resource.otp_provisioning_uri)
      end

      private

      def otp_authenticator_token_image_google(otp_url)
        otp_url = Rack::Utils.escape(otp_url)
        url = "https://chart.googleapis.com/chart?chs=200x200&chld=M|0&cht=qr&chl=#{otp_url}"
        image_tag(url, :alt => 'OTP Url QRCode')
      end

    end
  end
end
