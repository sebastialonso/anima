class ApplicationController < ActionController::Base
  include Passwordless::ControllerHelpers

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  helper_method :current_user

  private

  def current_user
    @current_user ||= authenticate_by_session(User)
  end

  def require_user!
    return if Rails.env.development? || (current_user && current_user.admin?)
    redirect_to root_path, alert: "You are not worthy!"
  end
end
