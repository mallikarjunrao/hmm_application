class CreateCardItems < ActiveRecord::Migration
  def self.up
    create_table :card_items do |t|
	t.column :card_id, :string
	t.column :image_type, "enum('family_icon','logo','text','background','image')"
	t.column :x, :float
	t.column :y, :float
	t.column :height, :float	
	t.column :width, :float
      	t.timestamps
    end
  end

  def self.down
    drop_table :card_items
  end
end
