# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :require_authentication
  def new
    redirect_to menu_index_path if current_user && session[:username]
    @user = User.new
  end

  def create
    user = User.find_by(username: params[:username])
    if !!user&.authenticate(params[:password])
      session[:username] = params[:username]
      redirect_to menu_index_path
    else
      redirect_to root_path, notice: 'Login to Play'
    end
  end

  def destroy
    session.clear
    redirect_to root_path
  end
end
