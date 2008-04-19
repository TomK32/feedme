class ExtendFeed < ActiveRecord::Migration
  def self.up
    change_column :feeds, :url, :text, :null => false # we won't down this
    add_column :feeds, :alternative_url, :text
    add_column :feeds, :type, :string, :default => 'Feed'
    add_column :feeds, :user_id, :integer
    add_column :feeds, :active, :boolean, :default => false
    add_column :feeds, :frequency, :string, :default => '1.day'
  end

  def self.down
    remove_column :feeds, :active
    remove_column :feeds, :frequency
    remove_column :feeds, :user_id
    remove_column :feeds, :type
    remove_column :feeds, :url
  end
end
