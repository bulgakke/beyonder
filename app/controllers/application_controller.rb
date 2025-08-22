class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  include ActiveStorage::SetCurrent

  include Authentication
  include Pundit::Authorization
  after_action :verify_pundit_authorization

  def verify_pundit_authorization
    if action_name == "index"
      verify_policy_scoped
    else
      verify_authorized
    end
  end

  rescue_from ActiveRecord::RecordNotFound do
    render_not_found!
  end

  def render_not_found!
    render file: "public/404.html", status: :not_found
  end

  # Pundit calls current_user in `authorize`
  def current_user
    Current.user
  end
end
