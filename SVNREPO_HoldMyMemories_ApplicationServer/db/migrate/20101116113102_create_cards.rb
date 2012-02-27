class CreateCards < ActiveRecord::Migration
  def self.up
    create_table :cards do |t|
	t.column :image_name, :string,:default=>""
	t.column :image_path, :string
	t.column :height, :float
	t.column :width, :float
	t.column :image_type, "enum('background')"
	t.column :img_url,:string	
	t.timestamps
    end
  end

  def self.down
    drop_table :cards
  end
end
