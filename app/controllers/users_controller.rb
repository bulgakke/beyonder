class UsersController < ApplicationController
  allow_unauthenticated_access only: %i[new create]

  def new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      start_new_session_for @user
    else
      render :new, status: :unprocessable_entity
    end
  end

  def user_params
    if params[:email].present?
      params.permit(:username, :email, :password)
    else
      { username: params[:username], password: 'nope' }
    end
  end
end
