# Devise::Otp ( MFA OTP, minified and mongoized)
**I highly recommend that you encrypt your otp_auth_secret and otp_recovery_secret fields in your database. Storing them in plain-text removes a lot of the security form this authentication method.**

**Data is stored in the session which will be changed later to save this information in the DB, but for now you MUST have encrypted cookies for this library to be effective.**

Devise OTP implements multi-factor authentication for Devise, using an rfc6238 compatible Time-Based One-Time Password Algorithm.

It uses the [rotp library](https://github.com/mdp/rotp) for generation and verification of codes.

It currently has the following features:

* Url based provisioning of token devices, compatible with **Google Authenticator**.
* Multi-factor authentication can be **optional** at user discretion or **mandatory** users must enroll OTP after signing-in next time, before they can navigate the site. The settings is global, or per-user.
* Users can obtain a list of HOTP recovery tokens to be used for emergency log-in in case the token device is lost or unavailable.

Compatible token devices are:

* [Google Authenticator](https://code.google.com/p/google-authenticator/)
* [FreeOTP](https://fedorahosted.org/freeotp/)

## Quick overview of Multi-Factor Authentication using OTPs.

* A shared secret is generated on the server, and stored both on the token device (ie: the phone) and the server itself.
* The secret is used to generate short numerical tokens that are either time or sequence based.
* Tokens can be generated on a phone without internet connectivity.
* OTP in this project is used as a second layer of security after a password has been provided. This provides layered security for users.
* The token provides an additional layer of security against password theft.
* Google Authenticator allows you to store multiple OTP secrets and provision those using a QR Code

Although there's an adjustable drift window, it is important that both the server and the token device (phone) have their clocks set (eg: using NTP).

## Installation

Add this line to your application's Gemfile:

    gem 'devise'
    gem 'devise-otp-min-mongo'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install devise-otp-min-mongo


### Devise Installation

To setup Devise, you need to do the following (but refer to https://github.com/plataformatec/devise for more information)

Install Devise:

    rails g devise:install

Setup the User or Admin model

    rails g devise MODEL

### Automatic Installation

Run the following generator to add the necessary configuration options to Devise's config file:

    rails g devise_otp:install

After you've created your Devise user models (which is usually done with a "rails g devise MODEL"), set up your Devise OTP additions:

    rails g devise_otp MODEL

### Custom Views

-- Will extract HAML views from my application soon.

### I18n

-- Will extract locale file from application soon.

## Usage

With this extension enabled, the following is expected behaviour:

* Users may go to _/MODEL/otp/token and enable their OTP state, they might be asked to provide their password again (and OTP token, if it's enabled)
* Once enabled they're shown an alphanumeric code (for manual provisioning) and a QR code, for automatic provisioning of their authetication device (for instance, Google Authenticator)
* If config.otp_mandatory or model_instance.otp_mandatory, users will be required to enable, and provision, next time they successfully sign-in.


### Configuration Options

The install generator adds some options to the end of your Devise config file (config/initializers/devise.rb)

* `config.otp_mandatory` - OTP is mandatory, users are going to be asked to enroll the next time they sign in, before they can successfully complete the session establishment.
* `config.otp_authentication_timeout` - how long the user has to authenticate with their token. (defaults to `3.minutes`)
* `config.otp_drift_window` - a window which provides allowance for drift between a user's token device clock (and therefore their OTP tokens) and the authentication server's clock. Expressed in minutes centered at the current time. (default: `3`)
* `config.otp_credentials_refresh` - Users that have logged in longer than this time ago, are going to be asked their password (and an OTP challenge, if enabled) before they can see or change their otp informations. (defaults to `15.minutes`)
* `config.otp_recovery_tokens` - Whether the users are given a list of one-time recovery tokens, for emergency access (default: `10`, set to `false` to disable)
* `config.otp_uri_application` - The name of this application, to be added to the provisioning url as '<user_email>/application_name' (defaults to the Rails application class)
* `config.otp_authentication_after_sign_in` - Whether the sign in requires OTP once enabled (default: false, set to `true` to enable)
* `config.otp_return_path` - return path after succcessful authentication (default: "root") 

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Thanks

I later started mine by forking https://github.com/wmlele/devise-otp. It was the simpliest one I found that seemed like a good base to build from. My project seems to have different intentions, I use my multi-factor OTP as a mulit-layered security system instead of providing an alernative authentication route. The original author was very friendly and helpful, thanks.

"I started this extension by forking [devise_google_authenticator](https://github.com/AsteriskLabs/devise_google_authenticator), and this project still contains some chunk of code from it, esp. in the tests and generators.
At some point, my design goals were significantly diverging, so I refactored most of its code. Still, I want to thank the original author for his relevant contribution." - Author who I forked from.

## License

MIT Licensed
