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
    enabled =  (params[resource_name][:mfa_enabled] == '1')
    if (enabled ? resource.enable_mfa : resource.disable_mfa)
      mfa_set_flash_message :success, :successfully_updated
    end
    render :show
  end

  private
    def ensure_credentials_refresh
      if resource.mfa_enabled? and needs_credentials_refresh?(resource)
        mfa_set_flash_message :notice, :need_to_refresh_credentials
        redirect_to refresh_mfa_credential_path_for(resource)
      end
    end
end
