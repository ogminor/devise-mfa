class DeviseMfa::CredentialsController < DeviseController
  helper_method :new_session_path
  prepend_before_filter :authenticate_scope!, only: [:get_refresh, :set_refresh]

  def get_refresh
    render :refresh
  end

  def set_refresh
    recovery = (params[resource_name][:recovery] == 'true') and recovery_enabled?
    if resource.mfa_enabled?
      if recovery and resource.validate_mfa_token(params[resource_name][:token], recovery)
        done_valid_refresh
      elsif resource.validate_mfa_token(params[resource_name][:token])
        done_valid_refresh
      else
        failed_refresh
      end
    else
      done_valid_refresh
    end
  end

  private
    def done_valid_refresh
      resource.update_attributes(mfa_refresh_on: (Time.now + resource.class.mfa_credentials_refresh))
      mfa_set_flash_message :success, :valid_refresh if is_navigational_format?
      respond_with resource, location: (resource.mfa_refresh_return_url.nil? ? resource.class.mfa_return_path.to_sym : resource.mfa_refresh_return_url)
    end

    def failed_refresh
      mfa_set_flash_message :alert, :invalid_refresh
      render :refresh
    end
end
