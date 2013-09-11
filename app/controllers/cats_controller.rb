class CatsController < ApplicationController

  def index
    @cats = Cat.all
  end

  def show
    @cat = Cat.find(params[:id])
  end

  def new

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
end
