require 'feed_tools'

class Feed < ActiveRecord::Base
  has_many :articles, :dependent => :delete_all
  
  validates_presence_of :title
  validates_presence_of :url
  belongs_to :user
  
  def refresh
    feed = FeedTools::Feed.open(self.url)
    feed.items.each do |item|
      next if Article.find_by_link(item.link)
      content = ""
      content = item.description unless item.description.blank?
      content += item.content unless item.content.blank?
      article = self.articles.create(
        :author => item.author.name,
        :content => content,
        :link => item.link,
        :published => item.published,
        :title => item.title
        )
    end
  end
end
