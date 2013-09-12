class CatsController < ApplicationController
  before_filter :check_owner, only: [:edit]

  def index
    @cats = Cat.all
  end

  def show
    @cat = Cat.where(id: params[:id]).includes(:requests).first
  end

  def new
    unless self.current_user
      flash.notice = "Must be logged in to create a cat"
      redirect_to new_session_url
    end
  end

  def update
    @cat = Cat.find(params[:id])
    @cat.update_attributes(params[:cat])

    if @cat.save
      redirect_to cat_url @cat.id
    else
      flash.notice = "Update failed"
      redirect_to cats_url
    end

  end

  def edit
    @cat = Cat.find(params[:id])
  end

  def create
    @cat = current_user.cats.build(params[:cat])

  #  params[:cat][:user_id] = self.current_user.id
     #@cat = Cat.new(params[:cat])

    if @cat.save
      redirect_to cat_url @cat.id
    else
      flash.notice = "Save failed"
      redirect_to cats_url
    end
  end

  def destroy
    @cat = Cat.find(params[:id])

    if @cat.destroy
      redirect_to cats_url
    else
      flash.notice = "Delete failed"
      redirect_to cats_url
    end
  end

  def check_owner
    @cat = Cat.find(params[:id])
    unless self.current_user.id == @cat.user_id
      flash.notice = "Can only edit your own cat"
      redirect_to cats_url
    end
  end

end