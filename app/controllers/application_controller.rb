class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Disabling caching will prevent sensitive information being stored in the
  # browser cache. If your app does not deal with sensitive information then it
  # may be worth enabling caching for performance.
  before_action :update_headers_to_disable_caching

  before_action :configure_sign_up_params, if: :devise_controller?
  before_action :configure_account_update_params, if: :devise_controller?
  # Check for compromised password
  def after_sign_in_path_for(resource)
    set_flash_message! :alert, :warn_pwned if resource.respond_to?(:pwned?) &&
    resource.pwned?
    super
  end
    protected
    # If you have extra params to permit, append them to the sanitizer.
    def configure_sign_up_params
      devise_parameter_sanitizer.permit(:sign_up, keys: [:full_name])
    end

    # If you have extra params to permit, append them to the sanitizer.
    def configure_account_update_params
      devise_parameter_sanitizer.permit(:account_update, keys: [:full_name])
    end

  private
    def update_headers_to_disable_caching
      response.headers['Cache-Control'] = 'no-cache, no-cache="set-cookie", no-store, private, proxy-revalidate'
      response.headers['Pragma'] = 'no-cache'
      response.headers['Expires'] = '-1'
    end
end
