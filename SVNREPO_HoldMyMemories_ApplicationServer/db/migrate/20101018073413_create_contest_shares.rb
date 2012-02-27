class CreateContestShares < ActiveRecord::Migration
  def self.up
    create_table :contest_shares do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :contest_shares
  end
end
