class CreateCardPrices < ActiveRecord::Migration
  def self.up
    create_table :card_prices do |t|
      t.column :card_id,:integer
      t.column :studio_id,:integer
      t.column :price,:integer
      t.timestamps
    end
  end

  def self.down
    drop_table :card_prices
  end
end
