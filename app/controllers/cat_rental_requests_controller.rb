class CatRentalRequestsController < ApplicationController
    before_filter :check_owner, only: [:edit, :approve, :deny]

  def new
    @cats = Cat.all
  end

  def create
    @cat_rental_request = CatRentalRequest.new(params[:cat_rental_request])

    if @cat_rental_request.save
      redirect_to cats_url
    else
      flash.notice = "Save failed"

      redirect_to :back
    end
  end

  def approve
    rent = CatRentalRequest.find(params[:id])
    rent.approve!
    redirect_to cat_url(rent.cat_id)
  end

  def deny
    rent = CatRentalRequest.find(params[:id])
    rent.deny!
    redirect_to cat_url(rent.cat_id)
  end

  def check_owner
    @cat = CatRentalRequest.find(params[:id]).cat
    unless current_user.id == @cat.user_id
      flash.notice = "Can only confirm/deny reservations for your own cat"
      redirect_to cats_url
    end
  end

end