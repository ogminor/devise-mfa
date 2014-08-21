module ActionDispatch::Routing
  class Mapper

    protected
      def devise_mfa(mapping, controllers)
        namespace :mfa, :module => :devise_mfa do
          resource :token, only: [:show, :update], path: mapping.path_names[:token], controller: controllers[:mfa_tokens]

          resource :credential, only: [], path: mapping.path_names[:credentials], controller: controllers[:mfa_credentials] do
            get :validate, action: 'get_refresh'
            put :validate, action: 'set_refresh'
          end
        end
      end
  end
end
