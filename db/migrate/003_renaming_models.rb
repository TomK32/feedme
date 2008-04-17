class RenamingModels < ActiveRecord::Migration
  def self.up
    rename_table :rss_feeds, :feeds
    rename_table :rss_articles, :articles
    rename_column :articles, :rss_feed_id, :feed_id
  end

  def self.down
    rename_column :articles, :feed_id, :rss_feed_id
    rename_table :feeds, :rss_feeds
    rename_table :articles, :rss_articles
  end
end
