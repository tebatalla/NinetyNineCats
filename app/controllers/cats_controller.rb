class CatsController < ApplicationController
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

  private
  def cat_params
    params.require(:cat).permit([:name, :sex, :color, :description, :birth_date])
  end
end
