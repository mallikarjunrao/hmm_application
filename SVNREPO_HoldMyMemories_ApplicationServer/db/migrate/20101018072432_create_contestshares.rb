class CreateContestshares < ActiveRecord::Migration
  def self.up
    create_table :contestshares do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :contestshares
  end
end
