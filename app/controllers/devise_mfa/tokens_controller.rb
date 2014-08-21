class DeviseMfa::TokensController < DeviseController
  include Devise::Controllers::Helpers
  prepend_before_filter :ensure_credentials_refresh
  prepend_before_filter :authenticate_scope!

  def show
   if resource.nil?
      redirect_to stored_location_for(resource_name.to_sym) || :root
    else
      render :show
    end
  end

  def update
    enabled =  (params[resource_name][:otp_enabled] == '1')
    if (enabled ? resource.enable_otp : resource.disable_otp)
      otp_set_flash_message :success, :successfully_updated
    end
    render :show
  end

  private
    def ensure_credentials_refresh
      ensure_resource!
      if resource.otp_enabled? and needs_credentials_refresh?(resource)
        otp_set_flash_message :notice, :need_to_refresh_credentials
        redirect_to refresh_otp_credential_path_for(resource)
      end
    end
end
