# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :require_authentication
  def new
    @user = User.new
  end

  def create
    user = User.find_by(username: params[:username])
    if !!user&.authenticate(params[:password])
      session[:username] = params[:username]
      redirect_to menu_index_path
    else
      redirect_to new_sessions_path, notice: 'Login to Play'
    end
  end

  def destroy
    session.clear
    redirect_to new_sessions_path
  end
end
