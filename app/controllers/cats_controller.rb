class CatsController < ApplicationController
  before_action :is_cat_owner, only: [:edit, :update]

  def index
    @cats = Cat.all.order(:id)
    render :index
  end

  def show
    @cat = Cat.find(params[:id])
    @cat_attributes = @cat.cat_attributes
    render :show
  end

  def new
    @cat = Cat.new
    render :new
  end

  def create
    @cat = Cat.new(cat_params)
    @cat.user_id = current_user.id
    if @cat.save
      redirect_to cat_url(@cat)
    else
      render :new
    end
  end

  def edit
    @cat = Cat.find(params[:id])
    render :edit
  end

  def update
    @cat = Cat.update(params[:id], cat_params)
    if @cat.save
      redirect_to cat_url(@cat)
    else
      render :edit
    end
  end

  def destroy
    @cat = Cat.find(params[:id])
    @cat.try(:destroy)
    redirect_to cats_url
  end

  private
  def cat_params
    params.require(:cat).permit([:name, :sex, :color, :description, :birth_date])
  end

  def is_cat_owner
    cat = Cat.find(params[:id])
    if current_user != cat.owner
      redirect_to cats_url
    end
  end
end
