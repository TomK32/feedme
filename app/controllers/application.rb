# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '968950020761706555ec8cff0354afad'
  
  protected
  def current_user
    # will hit the query cache in any case
    @current_user ||= User.find(session[:goldberg][:user_id]) rescue nil
  end
  def get_feeds
    @feeds = Feed.find :all, :order => 'title'
  end
end
