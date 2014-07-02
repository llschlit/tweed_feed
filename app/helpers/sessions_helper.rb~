module SessionsHelper

  def sign_in(user)
    remember_token = User.new_remember_token 			# create a new token
    cookies.permanent[:remember_token] = remember_token		# place the raw token in the browser cookies
    user.update_attribute(:remember_token, User.digest(remember_token)) #save the hashed token to the database
    self.current_user = user 					# set the current user equal to the given user
  end

  def signed_in?
    !current_user.nil?
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user # used to redefine the correct user based on cookie each time a new page is viewed
    remember_token = User.digest(cookies[:remember_token])
    # the ||=, or equals, only sets current_user if it's undefined
    @current_user ||= User.find_by(remember_token: remember_token)
  end

  def current_user?(user)
    user == current_user
  end

  def sign_out
    # when a user signs out, change their cookie as a security precaution
    current_user.update_attribute(:remember_token,
				  User.digest(User.new_remember_token) )
    # delete the user's cookie from their browser
    cookies.delete(:remember_token)
    # set current_user of site to nil
    self.current_user = nil
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url if request.get?
  end
end
