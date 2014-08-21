class DeviseOtp::TokensController < DeviseController
  include Devise::Controllers::Helpers
  prepend_before_filter :ensure_credentials_refresh
  prepend_before_filter :authenticate_scope!

  def show
   if resource.nil?
      redirect_to stored_location_for(scope) || :root
    else
      render :show
    end
  end

  def update
    enabled =  (params[resource_name][:otp_enabled] == '1')
    if (enabled ? resource.enable_otp! : resource.disable_otp!)

      otp_set_flash_message :success, :successfully_updated
    end
    render :show
  end

  def destroy
    if resource.reset_otp_credentials!
      otp_set_flash_message :success, :successfully_reset_creds
    end
    redirect_to resource.class.otp_return_path
  end

  private

    def ensure_credentials_refresh
      ensure_resource!
      # This code makes me ;_;
      if (!resource.otp_enabled? and resource.class.otp_authentication_after_sign_in)
        # Skip password check on initial setup when using OTP as on separate login screen
      elsif needs_credentials_refresh?(resource)
        otp_set_flash_message :notice, :need_to_refresh_credentials
        redirect_to refresh_otp_credential_path_for(resource)
      end
    end

    def scope
      resource_name.to_sym
    end
end
