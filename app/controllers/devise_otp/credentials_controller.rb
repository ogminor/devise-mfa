class DeviseOtp::CredentialsController < DeviseController
  helper_method :new_session_path

  prepend_before_filter :authenticate_scope!, :only => [:get_refresh, :set_refresh]

  # displays the request for a credentials refresh
  #
  def get_refresh
    ensure_resource!
    render :refresh
  end

  #
  # lets the user through is the refresh is valid
  #
  def set_refresh
    recovery = (params[resource_name][:recovery] == 'true') && recovery_enabled?
    ensure_resource!
    # I am sure there's a much better way
    if resource.class.otp_authentication_after_sign_in or resource.valid_password?(params[resource_name][:refresh_password])
      if resource.otp_enabled?
        if recovery and resource.validate_otp_token(params[resource_name][:token], recovery)
          done_valid_refresh
        elsif resource.validate_otp_token(params[resource_name][:token])
          done_valid_refresh
        else
          failed_refresh
        end
      else
        done_valid_refresh
      end
    else
      failed_refresh
    end
  end

  private

    def done_valid_refresh
      otp_refresh_credentials_for(resource)
      otp_set_flash_message :success, :valid_refresh if is_navigational_format?

      respond_with resource, :location => otp_fetch_refresh_return_url
    end

    def failed_refresh
      otp_set_flash_message :alert, :invalid_refresh
      render :refresh
    end

end
