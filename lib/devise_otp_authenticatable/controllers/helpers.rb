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
        resource.class.otp_recovery_tokens  (resource.class.otp_recovery_tokens > 0)
      end

      def needs_credentials_refresh?(resource)
        if resource.otp_refresh_on < Time.now
          otp_set_refresh_return_url
        else
          false        
        end
      end

      def otp_refresh_credentials_for(resource)
        resource.otp_refresh_on = (Time.now + resource.class.otp_credentials_refresh)
      end

      def otp_authenticator_token_image(resource)
        qr = ['data:image/png;base64,', RQRCode::QRCode.new(resource.otp_provisioning_uri, :size => 9, :level => :h ).to_img.resize(250,250).to_blob].pack('A*m').gsub(/\n/, '')
        image_tag(qr, alt: 'OTP Url QRCode')
      end

    end
  end
end
