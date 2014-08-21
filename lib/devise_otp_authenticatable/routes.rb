module ActionDispatch::Routing
  class Mapper

    protected
    
      def devise_otp(mapping, controllers)
        namespace :otp, :module => :devise_otp do
          resource :token, only: [:show, :update], path: mapping.path_names[:token], controller: controllers[:otp_tokens]

          resource :credential, only: [], path: mapping.path_names[:credentials], controller: controllers[:otp_credentials] do
            get :validate, action: 'get_refresh'
            put :validate, action: 'set_refresh'
          end
        end
      end
  end
end
