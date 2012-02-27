class CreateCardCarts < ActiveRecord::Migration
  def self.up
    create_table :card_carts do |t|
      t.column :user_id,:integer
      t.column :card_id,:integer
      t.column :image_data,:string
      t.column :quantity,:integer
      t.column :size_id,:integer
      t.column :status,"enum('cart','order_print')"
      t.column :order_no,:integer
      t.column :order_type,"enum('hmm','other')"
      t.timestamps
    end
  end

  def self.down
    drop_table :card_carts
  end
end
