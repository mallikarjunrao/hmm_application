class AddCardsOrderColumnToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders,:cards_order,:boolean,:default=>false
  end

  def self.down
  end
end
