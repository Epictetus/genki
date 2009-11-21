class AddTeasersToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :teaser_html, :text
  end

  def self.down
    remove_column :posts, :teaser_html
  end
end
