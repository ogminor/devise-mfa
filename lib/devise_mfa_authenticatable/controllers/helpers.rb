module DeviseMfaAuthenticatable
  module Controllers
    module Helpers

      def authenticate_scope!
        send(:"authenticate_#{resource_name}!", :force => true)
        self.resource = send("current_#{resource_name}")
      end

      def mfa_set_flash_message(key, kind, options={})
        options[:scope] ||= "devise.mfa.#{controller_name}"
        options[:default] = Array(options[:default]).unshift(kind.to_sym)
        options[:resource_name] = resource_name
        options = devise_i18n_options(options) if respond_to?(:devise_i18n_options, true)
        message = I18n.t("#{options[:resource_name]}.#{kind}", options)
        flash[key] = message if message.present?
      end

      def recovery_enabled?
        resource.class.mfa_recovery_tokens and (resource.class.mfa_recovery_tokens > 0)
      end

      def needs_credentials_refresh?(resource)
        if resource.mfa_refresh_on < Time.now
          true
        else
          false        
        end
      end

      def mfa_set_refresh_return_url
        resource.mfa_refresh_return_url = request.fullpath
      end

      def mfa_refresh_credentials_for(resource)
        resource.mfa_refresh_on = (Time.now + resource.class.mfa_credentials_refresh)
      end

      def mfa_authenticator_token_image(resource)
        qr = ['data:image/png;base64,', RQRCode::QRCode.new(resource.mfa_provisioning_uri, :size => 9, :level => :h ).to_img.resize(250,250).to_blob].pack('A*m').gsub(/\n/, '')
        image_tag(qr, alt: 'MFA QRCode')
      end

    end
  end
end
