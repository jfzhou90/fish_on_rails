# frozen_string_literal: true

class SignupController < ApplicationController
  skip_before_action :require_authentication
  def index
    @user = User.new
  end

  def create
    user = User.new(user_params)
    if user.save
      session[:username] = user.username
      redirect_to menu_index_path, notice: 'Logged in successfully'
    else
      redirect_to signup_index_path, notice: 'Unable to create user, try again.'
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation)
  end
end
