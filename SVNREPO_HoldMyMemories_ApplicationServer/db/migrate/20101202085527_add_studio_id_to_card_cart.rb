class AddStudioIdToCardCart < ActiveRecord::Migration
  def self.up
    add_column :card_carts,:studio_id,:integer
  end

  def self.down
  end
end
