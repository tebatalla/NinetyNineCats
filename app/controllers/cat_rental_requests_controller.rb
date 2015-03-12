class CatRentalRequestsController < ApplicationController
  before_action :require_user_is_cat_owner, only: [:approve, :deny]
  before_action :require_signed_in

  def new
    @cat_rental_request = CatRentalRequest.new
    render :new
  end

  def edit
    @cat_rental_request = CatRentalRequest.find(params[:id])
    render :edit
  end

  def update
    @cat_rental_request = CatRentalRequest.update(cat_rental_request_params)
    if @cat_rental_request.save
      redirect_to cat_url(@cat_rental_request.cat_id)
    else
      render :edit
    end
  end

  def destroy
    @cat_rental_request = CatRentalRequest.find(params[:id])
    @cat_rental_request.try(:destroy)
    redirect_to cat_url(@cat_rental_request.cat_id)
  end

  def create
    @cat_rental_request = CatRentalRequest.new(cat_rental_request_params)
    @cat_rental_request.user_id = current_user.id
    if @cat_rental_request.save
      redirect_to cat_url(@cat_rental_request.cat_id)
    else
      render :new
    end
  end

  def approve
    @cat_rental_request = CatRentalRequest.find(params[:id])
    @cat_rental_request.approve!
    redirect_to cat_url(@cat_rental_request.cat_id)
  end

  def deny
    @cat_rental_request = CatRentalRequest.find(params[:id])
    @cat_rental_request.deny!
    redirect_to cat_url(@cat_rental_request.cat_id)
  end

  private
  def cat_rental_request_params
    params.require(:cat_rental_request).permit([:cat_id, :start_date, :end_date])
  end

  def require_user_is_cat_owner
    cat = CatRentalRequest.find(params[:id]).cat
    if current_user != cat.owner
      redirect_to cats_url
    end
  end
end
