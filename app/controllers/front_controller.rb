class FrontController < ApplicationController
  before_filter :get_feeds
  
  def index
    if params[:year].nil? or params[:month].nil? or params[:day].nil?
        @current_date = Time.now
      @articles = Article.find :all, :order => 'published DESC', :limit => 10
    else
        @current_date = Time.parse("#{params[:year]}-#{params[:month]}-#{params[:day]}")
        @articles = Article.find :all, :include => :feed,
                                    :conditions => ['published BETWEEN ? AND ?', @current_date.beginning_of_day, @current_date.end_of_day],
                                    :order => 'published DESC'
    end
  end

end
