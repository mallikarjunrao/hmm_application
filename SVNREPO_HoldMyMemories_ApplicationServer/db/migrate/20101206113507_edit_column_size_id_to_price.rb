class EditColumnSizeIdToPrice < ActiveRecord::Migration
  def self.up
    add_column :card_carts,:price,:float
    add_column :card_carts,:net_price,:float
  end

  def self.down
  end
end
