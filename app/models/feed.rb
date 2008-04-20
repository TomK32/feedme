require 'feed_tools'
require 'hpricot'

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
      content += item.content unless item.content.blank? or item.content == item.description
      parsed_content = Hpricot.parse(content)
      # removing feedburner garbage
      parsed_content.search('/div.feedflare').remove
      parsed_content.search('/img[@src.match/^http://feeds.feedburner.com/~r/]').remove

      article = self.articles.create(
        :author => item.author.name,
        :content => parsed_content.to_s,
        :link => item.link,
        :published => item.published,
        :title => item.title
        )
    end
  end
end
