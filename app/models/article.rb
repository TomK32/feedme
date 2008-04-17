class Article < ActiveRecord::Base
  belongs_to :feed
  
  validates_presence_of :feed_id
  validates_numericality_of :feed_id
end
