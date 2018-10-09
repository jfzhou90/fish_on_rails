# frozen_string_literal: true

class MenuController < ApplicationController
  def index
    @user = current_user
  end
end
