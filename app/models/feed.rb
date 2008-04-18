require 'hpricot'
require 'open-uri'

class Feed < ActiveRecord::Base
  has_many :articles, :dependent => :delete_all
  
  validates_presence_of :title
  validates_presence_of :url
  belongs_to :user
  
  def refresh
    process_feed(pull_feed)
  end
  
  def process_feed(xml)
    doc = Hpricot.XML(xml)
    
    if doc.search(:rss).size > 0
      process_rss_feed(doc)
      return 'rss'
    elsif doc.search(:feed).size > 0
      process_atom_feed(doc)
      return 'atom'
    else
      raise RuntimeError, "Unknown Feed Type for '#{url}'! Only RSS 2.0 & Atom can be read."
    end
  end
  
  def process_rss_feed(rss)
    time_offset = 1
    
    (rss/:channel/:item).each do |item|
      link = (item/:link).inner_html
      
      if not Article.find_by_link(link)
        rss_article = Article.new
        rss_article.feed = self
        rss_article.title = (item/:title).inner_html
        rss_article.link = link
        rss_article.author = (item/:author).inner_html
        rss_article.content = (item/:description).inner_html
        rss_article.published = (item/:pubDate).inner_html
        
        if not rss_article.published
          rss_article.published = Time.now - time_offset.hours
          time_offset += 1
        end
        
        # Fix the content to be HTML once again...
        rss_article.title = bring_back_the_html(rss_article.title)
        rss_article.content = bring_back_the_html(rss_article.content)
        
        rss_article.save()
      end
    end
  end
  
  def process_atom_feed(atom)
    time_offset = 1
    
    (atom/:entry).each do |item|
      link = (item/:link).attr('href')
      
      if not Article.find_by_link(link)
        atom_article = Article.new
        atom_article.feed = self
        atom_article.title = (item/:title).inner_html
        atom_article.link = link
        atom_article.author = (item/:author/:name).inner_html
        atom_article.content = (item/:content).inner_html
        atom_article.published = (item/:published).inner_html
        
        if not atom_article.content
          atom_article.content = (item/:summary).inner_html
        end
        
        if not atom_article.published
          atom_article.published = Time.now - time_offset.hours
          time_offset += 1
        end
        
        # Fix the content to be HTML once again...
        atom_article.title = bring_back_the_html(atom_article.title)
        atom_article.content = bring_back_the_html(atom_article.content)
        
        atom_article.save()
      end
    end
  end
  
  def pull_feed
    the_rss = ""
    f = open(self.url, 'r')
    the_rss = f.read()
    f.close 
    the_rss
  end
  
  def bring_back_the_html(stringy)
    stringy.gsub!('&lt;', '<')
    stringy.gsub!('&gt;', '>')
    stringy.gsub!('&amp;', '&')
    stringy.gsub!('&#39;', "'")
    stringy.gsub!('&quot;', '"')
    stringy
  end
end
