# This file is autogenerated. Instead of editing this file, please use the
# migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.

ActiveRecord::Schema.define() do

  create_table "blocked_times", :force => true do |t|
    t.column "start_time",    :integer, :limit => 10, :null => false
    t.column "end_time",      :integer, :limit => 10, :null => false
    t.column "block_on",      :date,                  :null => false
    t.column "error_message", :string,                :null => false
  end

  create_table "cupcakes", :force => true do |t|
    t.column "title",        :string,                     :null => false
    t.column "description",  :text
    t.column "slug",         :string,                     :null => false
    t.column "image_file",   :string,                     :null => false
    t.column "is_breakfast", :boolean, :default => false, :null => false
  end

  add_index "cupcakes", ["slug"], :name => "index_cupcakes_on_slug"

  create_table "cupcakes_days", :force => true do |t|
    t.column "cupcake_id", :integer, :null => false
    t.column "day_id",     :integer, :null => false
  end

  create_table "days", :force => true do |t|
    t.column "title",        :string,              :null => false
    t.column "abbreviation", :string, :limit => 4, :null => false
  end

  create_table "dyno_images", :force => true do |t|
    t.column "dyno_page_id", :integer, :null => false
    t.column "caption",      :string,  :null => false
    t.column "image",        :string
    t.column "thumb",        :string
    t.column "position",     :integer
  end

  create_table "dyno_pages", :force => true do |t|
    t.column "dyno_type_id", :integer,                                   :null => false
    t.column "title",        :string,                                    :null => false
    t.column "sub_title",    :string
    t.column "slug",         :string,                                    :null => false
    t.column "uri",          :string,                                    :null => false
    t.column "summary",      :string,  :limit => 1000
    t.column "page_on",      :date,                                      :null => false
    t.column "page_HTML",    :text,                                      :null => false
    t.column "is_active",    :boolean,                 :default => true, :null => false
  end

  add_index "dyno_pages", ["slug"], :name => "index_dyno_pages_on_slug"

  create_table "dyno_types", :force => true do |t|
    t.column "title", :string
    t.column "slug",  :string
  end

  add_index "dyno_types", ["slug"], :name => "index_dyno_types_on_slug"

  create_table "editable_texts", :force => true do |t|
    t.column "title",     :string, :null => false
    t.column "html_body", :text,   :null => false
  end

  create_table "faqs", :force => true do |t|
    t.column "position", :integer
    t.column "question", :string,  :limit => 512, :null => false
    t.column "answer",   :text,                   :null => false
  end

  create_table "owners", :force => true do |t|
    t.column "username", :string, :limit => 30, :null => false
    t.column "password", :string, :limit => 30, :null => false
    t.column "email",    :string
  end

  create_table "prices", :force => true do |t|
    t.column "title", :string, :limit => 55, :null => false
    t.column "price", :float,                :null => false
  end

  create_table "product_types", :force => true do |t|
    t.column "title",    :string,  :limit => 55, :null => false
    t.column "position", :integer
  end

  create_table "products", :force => true do |t|
    t.column "product_type_id", :integer,               :null => false
    t.column "title",           :string,  :limit => 55, :null => false
    t.column "price",           :float,                 :null => false
  end

  create_table "seo_settings", :force => true do |t|
    t.column "path",             :string,                :null => false
    t.column "page_title",       :string,                :null => false
    t.column "meta_keywords",    :string, :limit => 512, :null => false
    t.column "meta_description", :string, :limit => 512, :null => false
  end

  add_index "seo_settings", ["path"], :name => "index_seo_settings_on_path"

  create_table "sessions", :force => true do |t|
    t.column "sessid",     :string,   :null => false
    t.column "data",       :text,     :null => false
    t.column "updated_at", :datetime
    t.column "created_at", :datetime
  end

  create_table "subscribers", :force => true do |t|
    t.column "email_address", :string,               :null => false
    t.column "first_name",    :string, :limit => 50
    t.column "last_name",     :string, :limit => 50
    t.column "address1",      :string
    t.column "address2",      :string
    t.column "city",          :string,               :null => false
    t.column "state",         :string, :limit => 2,  :null => false
    t.column "zip",           :string, :limit => 15, :null => false
    t.column "subscribed_on", :date
  end

end