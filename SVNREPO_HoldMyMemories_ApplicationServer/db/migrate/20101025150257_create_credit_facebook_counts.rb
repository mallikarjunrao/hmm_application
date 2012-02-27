class CreateCreditFacebookCounts < ActiveRecord::Migration
  def self.up
    create_table :credit_facebook_counts do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :credit_facebook_counts
  end
end
