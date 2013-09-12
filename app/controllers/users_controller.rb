class UsersController < ApplicationController

  def new
    @user = User.new(params[:user])
  end

  def create
    @user = User.new(params[:user])

    if @user.save
      self.current_user = @user
      redirect_to cats_url
    else
      flash.notice = "Save failed"
      redirect_to new_user_url
    end
  end
end

