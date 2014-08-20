module ActionDispatch::Routing
  class Mapper

    protected
    
      def devise_otp(mapping, controllers)
        namespace :otp, :module => :devise_otp do
          resource :token, :only => [:show, :update, :destroy],
                   :path => mapping.path_names[:token], :controller => controllers[:otp_tokens]

          resource :credential :path => mapping.path_names[:credentials], :controller => controllers[:otp_credentials] do
            get  :refresh, :action => 'get_refresh'
            put :refresh, :action => 'set_refresh'
          end
        end
      end
  end
end
