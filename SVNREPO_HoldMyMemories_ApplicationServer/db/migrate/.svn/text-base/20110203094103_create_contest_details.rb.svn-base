class CreateContestDetails < ActiveRecord::Migration
  def self.up
    create_table :contest_details do |t|
      t.column :name, :string
      t.column :description, :text
      t.column :load_method_data, :string
      t.column :css_file, :string
      t.column :parse_id, :string
      t.column :rules_regulations, :text
      t.column :terms_conditions, :text
      t.column :terms_conditions, :text
      t.column :start_date, :date
      t.column :end_date, :date
      t.column :vote_expire_date, :date
      t.column :entry_end_date, :date
      t.timestamps
    end
  end

  def self.down
    drop_table :contest_details
  end
end
