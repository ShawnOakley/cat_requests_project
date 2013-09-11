class CatsController < ApplicationController

  def index
    @cats = Cat.all
  end

  def show
    @cat = Cat.where(id: params[:id]).includes(:requests).first
  end

  def new

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
    @cat = Cat.new(params[:cat])

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
end
