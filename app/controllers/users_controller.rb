class UsersController < ApplicationController
  before_action :require_not_signed_in, only: [:new, :create]
  before_action :require_signed_in, only: [:show]

  def new
    render :new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      login_user!(@user)
      redirect_to cats_url
    else
      render :new
    end
  end

  def show
    @user = current_user
    render :show
  end

  private
  def user_params
    params.require(:user).permit([:user_name, :password])
  end

end
