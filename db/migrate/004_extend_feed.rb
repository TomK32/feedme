class ExtendFeed < ActiveRecord::Migration
  def self.up
    change_column :feeds, :url, :text # we won't down this
    add_column :feeds, :other_url, :text
    add_column :feeds, :type, :string
    add_column :feeds, :user_id, :integer
    add_column :feeds, :frequency, :string
  end

  def self.down
    remove_column :feeds, :frequency
    remove_column :feeds, :user_id
    remove_column :feeds, :type
    remove_column :feeds, :url
  end
end
