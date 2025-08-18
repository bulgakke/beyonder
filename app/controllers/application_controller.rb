class ApplicationController < ActionController::Base
  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  rescue_from ActiveRecord::RecordNotFound do
    render_not_found!
  end

  def render_not_found!
    render file: "public/404.html", status: :not_found
  end
end
