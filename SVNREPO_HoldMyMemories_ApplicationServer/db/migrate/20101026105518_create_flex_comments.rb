class CreateFlexComments < ActiveRecord::Migration
  def self.up
    create_table :flex_comments do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :flex_comments
  end
end
