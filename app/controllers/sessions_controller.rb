class SessionsController < ApplicationController
  before_action :signed_in_redirect, only: [:new, :create]

  def new
    render :new
  end

  def create
    @user = User.find_by_credentials(session_params[:user_name], session_params[:password])
    if @user.nil?
      redirect_to new_session_url
    else
      login_user!(@user)
      redirect_to cats_url
    end
  end

  def destroy
    if params[:id]
      session = Session.find(params[:id])
      session.destroy if session.user == current_user
      redirect_to user_url
    else
      unless current_session.nil?
        current_session.destroy
        self.session[:token] = nil
      end
      redirect_to new_session_url
    end
  end

  private
  def session_params
    params.require(:user).permit([:user_name, :password])
  end
end
