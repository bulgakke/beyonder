class UsersController < ApplicationController
  allow_unauthenticated_access only: %i[create]

  before_action :set_user, only: %i[show]
  before_action :set_active_login_screen_tab, only: %i[create]

  def show
  end

  def me
    @user = Current.user

    render :show
  end

  def create
    @user = User.new(user_params)

    if @user.save
      start_new_session_for @user
      redirect_to after_authentication_url, notice: "Logged in as #{@user.username}"
    else
      redirect_to new_session_path(active_tab: @active_tab), alert: @user.errors.full_messages.join(", ")
    end
  end

  private

  def set_active_login_screen_tab
    @active_tab =
      if params[:email_address].present?
        "sign-up"
      else
        "quick-login"
      end
  end

  def user_params
    return temporary_user_params if params[:email_address].blank?

    params.permit(:username, :email_address, :password)
  end

  def temporary_user_params
    {
      username: "#{params[:username]}_#{rand(0..9999).to_s.rjust(4, "0")}",
      password: SecureRandom.hex(16)
    }
  end

  def set_user
    @user = User.find_by(username: params[:username])
  end
end
