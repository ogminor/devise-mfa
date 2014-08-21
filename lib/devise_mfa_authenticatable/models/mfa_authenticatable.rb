require 'rotp'

module Devise::Models
  module MfaAuthenticatable
    extend ActiveSupport::Concern

    included do
      before_validation :generate_mfa_auth_secret, :on => :create
    end

    module ClassMethods
      ::Devise::Models.config(self, :mfa_authentication_timeout, :mfa_drift_window, :mfa_authentication_after_sign_in, :mfa_return_path,
                                    :mfa_mandatory, :mfa_credentials_refresh, :mfa_uri_application, :mfa_recovery_tokens )
    end

    def time_based_mfa
      @time_based_mfa ||= ROTP::TOTP.new(mfa_auth_secret)
    end

    def recovery_mfa
      @recovery_mfa ||= ROTP::HOTP.new(mfa_recovery_secret)
    end

    def mfa_provisioning_uri
      time_based_mfa.provisioning_uri(mfa_provisioning_identifier)
    end

    def mfa_provisioning_identifier
      "#{email}/#{self.class.mfa_uri_application || Rails.application.class.parent_name}"
    end

    def enable_mfa
      update_attributes!(:mfa_enabled => true, :mfa_enabled_on => Time.now)
    end

    def disable_mfa
      @time_based_mfa = nil
      @recovery_mfa = nil
      generate_mfa_auth_secret
      update_attributes(:mfa_enabled => false,
                        :mfa_time_drift => 0,
                        :mfa_recovery_counter => 0)
    end

    def validate_mfa_token(token, recovery = false)
      if recovery
        validate_mfa_recovery_token token
      else
        validate_mfa_time_token token
      end
    end
    alias_method :valid_mfa_token?, :validate_mfa_token

    def validate_mfa_time_token(token)
      if token and drift = validate_mfa_token_with_drift(token)
        update_attribute(:mfa_time_drift, drift)
        true
      else
        false
      end
    end
    alias_method :valid_mfa_time_token?, :validate_mfa_time_token

    def next_mfa_recovery_tokens(number = self.class.mfa_recovery_tokens)
      (mfa_recovery_counter..mfa_recovery_counter + number).inject({}) do |h, index|
        h[index] = recovery_mfa.at(index)
        h
      end
    end

    def validate_mfa_recovery_token(token)
      recovery_mfa.verify(token, mfa_recovery_counter).tap do
        update_attributes(mfa_recovery_counter: (self.mfa_recovery_counter + 1))
      end
    end
    alias_method :valid_mfa_recovery_token?, :validate_mfa_recovery_token

    private
      def validate_mfa_token_with_drift(token)
        (-self.class.mfa_drift_window..self.class.mfa_drift_window).any? do |drift|
          (time_based_mfa.verify(token, Time.now.ago(30 * drift)))
        end
      end

      def generate_mfa_auth_secret
        self.mfa_auth_secret = ROTP::Base32.random_base32
        self.mfa_recovery_secret = ROTP::Base32.random_base32
      end
  end
end
