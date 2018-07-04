module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end

  # returns User object or nil
  def current_user
    # Idiomatic ruby : Hitting the database only once
    @current_user ||= User.find_by(id: session[:user_id])

    # Above code has same output as below
    # if @current_user.nil?
    #   @current_user = User.find_by(id: session[:user_id])
    # else
    #   @current_user
    # end
  end

  def logged_in?
    !current_user.nil?
  end

  def log_out
    session.delete(:user_id)
  end

  # Method that compares if the user is same with the logged in user
  def current_user?(user)
    current_user == user
  end

  def store_location
    session[:forwarding_url] = request.url
  end

  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)

    session.delete(:forwarding_url)
  end
end