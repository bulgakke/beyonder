class UsersController < ApplicationController
  allow_unauthenticated_access only: %i[create]

  before_action :set_user, only: %i[show]

  def show
  end

  def create
    @user = User.new(user_params)

    if @user.save
      start_new_session_for @user
      redirect_to after_authentication_url, notice: "Logged in as #{@user.username}"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def user_params
    if params[:email_address].present?
      params.permit(:username, :email_address, :password)
    else
      { username: params[:username], password: SecureRandom.hex(16) }
    end
  end

  private

  def set_user
    @user = User.find_by(username: params[:username])
  end
end
