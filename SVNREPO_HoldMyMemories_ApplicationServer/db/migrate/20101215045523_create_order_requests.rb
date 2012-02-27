class CreateOrderRequests < ActiveRecord::Migration
  def self.up
    create_table :order_requests do |t|
      t.column :owner_id,:integer
      t.column :email_address,:string
      t.column :message,:text
      t.column :requested_by,:string
      t.column :status, "enum('approved','rejected')"
      t.column :request_code,:string
      t.timestamps
    end
  end

  def self.down
    drop_table :order_requests
  end
end
