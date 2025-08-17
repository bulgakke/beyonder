class ApplicationController < ActionController::Base
  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  rescue_from ActiveRecord::RecordNotFound do
    render file: "public/404.html", status: :not_found, layout: false
  end

  def after_authentication_url
    session.delete(:return_to_after_authenticating) || user_url(Current.user)
  end
end
