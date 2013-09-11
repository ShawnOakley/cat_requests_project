class CatRentalRequestsController < ApplicationController

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

end