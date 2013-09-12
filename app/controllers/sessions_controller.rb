class SessionsController < ApplicationController
include SessionHelper
  def new

  end

  def create
    user = User.find_by_credentials(
      params[:user][:user_name],
      params[:user][:password])

    if user.nil?
      flash.notice = "Save failed"
      render :back
    else
      self.current_user = user
      redirect_to cats_url
      flash.notice = "Welcome back #{user.user_name}"
    end
  end

  def destroy
    logout_current_user!
    redirect_to new_session_url
  end
end
