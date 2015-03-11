class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user

  def current_user
    User.find_by(session_token: session[:token])
  end

  def login_user!(user)
    user.reset_session_token!
    self.session[:token] = user.session_token
  end

  def signed_in_redirect
    if current_user
      redirect_to cats_url
    end
  end
end
