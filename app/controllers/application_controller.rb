class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :current_session

  def current_user
    return nil if current_session.nil?
    User.find(current_session.user_id)
  end

  def current_session
    Session.find_by(token: session[:token])
  end

  def login_user!(user)
    session[:token] = Session.create(
      user_id: user.id,
      user_agent: request.env["HTTP_USER_AGENT"],
      location: request.location.address
    ).token
  end

  private

  def require_not_signed_in
    if current_user
      redirect_to cats_url
    end
  end

  def require_signed_in
    unless current_user
      redirect_to new_session_url
    end
  end

end
