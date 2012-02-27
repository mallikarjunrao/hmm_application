class CreateAddAvatarColumnsToUsers < ActiveRecord::Migration
  def self.up
    create_table :add_avatar_columns_to_users do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :add_avatar_columns_to_users
  end
end
