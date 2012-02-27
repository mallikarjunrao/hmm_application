# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110203094103) do

  create_table "aboutus_studios", :force => true do |t|
    t.integer  "studio_id"
    t.string   "studio_logo",   :limit => 100
    t.string   "aboutus_image", :limit => 100
    t.text     "description"
    t.datetime "created_at"
    t.datetime "modified_at"
  end

  create_table "abuses", :force => true do |t|
    t.string  "v_abused_by"
    t.integer "abused_user", :limit => 8
    t.string  "e_status",    :limit => 0, :default => "pending"
    t.text    "v_comment"
  end

  create_table "advertisement_details", :force => true do |t|
    t.integer "advid",                      :null => false
    t.string  "v_adtitle",    :limit => 50
    t.string  "v_adlink",     :limit => 50
    t.string  "v_adtag",      :limit => 50
    t.string  "v_filename"
    t.integer "i_imgwidth"
    t.integer "i_imgheight"
    t.integer "i_imgx"
    t.integer "i_imgy"
    t.string  "content_type"
    t.binary  "data",                       :null => false
  end

  add_index "advertisement_details", ["advid"], :name => "advertisement_FKIndex1"

  create_table "advertiser_details", :force => true do |t|
    t.string   "v_firstname",                :null => false
    t.string   "v_lastname",                 :null => false
    t.string   "v_username",                 :null => false
    t.string   "v_password",                 :null => false
    t.string   "v_company",                  :null => false
    t.string   "v_address",    :limit => 25, :null => false
    t.string   "v_city",                     :null => false
    t.string   "v_state",                    :null => false
    t.string   "v_country",                  :null => false
    t.string   "v_zip",                      :null => false
    t.string   "v_phone",                    :null => false
    t.string   "v_email",                    :null => false
    t.string   "e_gender",     :limit => 0,  :null => false
    t.datetime "d_created_at"
    t.datetime "d_updated_at"
    t.string   "v_plan",                     :null => false
    t.string   "e_status",     :limit => 0,  :null => false
  end

  create_table "air_plane", :force => true do |t|
    t.string "model"
    t.string "pilot"
    t.string "destination"
  end

  create_table "air_planes", :force => true do |t|
    t.string "model"
    t.string "pilot"
    t.string "destination"
  end

  create_table "airplanes", :force => true do |t|
    t.string "model"
    t.string "pilot"
    t.string "destination"
  end

  create_table "apn_devices", :force => true do |t|
    t.string   "token",              :default => "", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "last_registered_at"
  end

  add_index "apn_devices", ["token"], :name => "index_apn_devices_on_token", :unique => true

  create_table "apn_notifications", :force => true do |t|
    t.integer  "user_id",                                                           :null => false
    t.integer  "device_id",                                                         :null => false
    t.integer  "error_nb",                       :default => 0
    t.string   "device_language"
    t.string   "sound"
    t.string   "alert"
    t.text     "notes"
    t.integer  "badge"
    t.datetime "start_date",                                                        :null => false
    t.date     "end_date"
    t.string   "repeat",            :limit => 0, :default => "0 DAY",               :null => false
    t.time     "alert_before_time",              :default => '2000-01-01 00:00:00', :null => false
    t.datetime "send_at"
    t.datetime "sent_at"
    t.string   "status",            :limit => 0, :default => "active",              :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "auto_shares", :force => true do |t|
    t.string   "share_type",    :limit => 0,   :null => false
    t.integer  "share_type_id",                :null => false
    t.string   "email",         :limit => 100, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bdrb_job_queues", :force => true do |t|
    t.text     "args"
    t.string   "worker_name"
    t.string   "worker_method"
    t.string   "job_key"
    t.integer  "taken"
    t.integer  "finished"
    t.integer  "timeout"
    t.integer  "priority"
    t.datetime "submitted_at"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.datetime "archived_at"
    t.string   "tag"
    t.string   "submitter_info"
    t.string   "runner_info"
    t.string   "worker_key"
    t.datetime "scheduled_at"
  end

  create_table "blog_comments", :force => true do |t|
    t.integer  "blog_id",                                          :null => false
    t.string   "name",       :limit => 100,                        :null => false
    t.text     "comment",                                          :null => false
    t.string   "status",     :limit => 0,   :default => "pending", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blogs", :force => true do |t|
    t.string   "blog_type",    :limit => 0,                        :null => false
    t.integer  "blog_type_id",              :default => 0,         :null => false
    t.integer  "user_id",                                          :null => false
    t.string   "title",                                            :null => false
    t.text     "description",                                      :null => false
    t.string   "client",       :limit => 0, :default => "website", :null => false
    t.string   "status",       :limit => 0, :default => "active",  :null => false
    t.datetime "added_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "book_sessions", :force => true do |t|
    t.string   "website_name"
    t.datetime "click_date"
  end

  create_table "booking_infos", :force => true do |t|
    t.integer  "studio_id",                  :null => false
    t.string   "phone_no",    :limit => 150, :null => false
    t.string   "email",                      :null => false
    t.string   "url",                        :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "modified_at"
  end

  create_table "business_managers", :force => true do |t|
    t.string   "business_manager_name"
    t.string   "business_manager_username", :null => false
    t.string   "business_manager_password", :null => false
    t.string   "business_manager_email",    :null => false
    t.datetime "created_at",                :null => false
    t.datetime "modified_at",               :null => false
  end

  create_table "cancellation_requests", :force => true do |t|
    t.integer  "uid"
    t.text     "reason_for_cancellation"
    t.date     "cancellation_request_date"
    t.date     "cancellation_date"
    t.string   "cancellation_status",       :limit => 0, :default => "pending", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "card_items", :force => true do |t|
    t.integer  "card_id",                  :null => false
    t.string   "image_type", :limit => 0,  :null => false
    t.float    "x",          :limit => 10, :null => false
    t.float    "y",          :limit => 10, :null => false
    t.float    "height",     :limit => 10, :null => false
    t.float    "width",      :limit => 10, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cards", :force => true do |t|
    t.string   "image_name",                                                                        :null => false
    t.string   "image_path",                                                                        :null => false
    t.float    "height",     :limit => 10,                                                          :null => false
    t.float    "width",      :limit => 10,                                                          :null => false
    t.string   "image_type", :limit => 0,  :default => "background",                                :null => false
    t.string   "img_url",                  :default => "http://stagingcontent.holdmymemories.com ", :null => false
    t.datetime "created_at",                                                                        :null => false
    t.datetime "updated_at",                                                                        :null => false
  end

  create_table "carts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "user_content_id",                                          :null => false
    t.string   "img_url",                                                  :null => false
    t.string   "original_image",                                           :null => false
    t.string   "print_image",                                              :null => false
    t.integer  "quantity",                                                 :null => false
    t.integer  "size_id",                                                  :null => false
    t.string   "status",          :limit => 0,  :default => "order_print", :null => false
    t.integer  "order_num",                     :default => 0,             :null => false
    t.text     "operations"
    t.integer  "studio_id",                     :default => 0
    t.string   "order_type",      :limit => 0,  :default => "hmm",         :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ordered_by",      :limit => 0
    t.integer  "visitor_id"
    t.string   "edited_image",    :limit => 50
  end

  create_table "chapter_comments", :force => true do |t|
    t.integer  "uid",          :limit => 8
    t.integer  "tag_id",       :limit => 8
    t.integer  "tag_jid",                   :default => 0
    t.string   "v_name"
    t.string   "v_e_mail"
    t.text     "v_comment",                                        :null => false
    t.datetime "d_created_on",                                     :null => false
    t.string   "e_approval",   :limit => 0, :default => "pending", :null => false
    t.string   "reply"
    t.string   "ctype",                     :default => "chapter"
  end

  create_table "chapter_journals", :force => true do |t|
    t.integer  "tag_id",        :limit => 8
    t.string   "v_tag_title",                                       :null => false
    t.text     "v_tag_journal",                                     :null => false
    t.datetime "d_created_at",                                      :null => false
    t.datetime "d_updated_at",                                      :null => false
    t.string   "jtype",                      :default => "chapter", :null => false
  end

  create_table "comments", :force => true do |t|
    t.string  "v_name",                        :null => false
    t.string  "v_email",                       :null => false
    t.integer "uid"
    t.integer "jid"
    t.string  "v_user_name"
    t.text    "v_comment",                     :null => false
    t.string  "e_acc_verify",     :limit => 0, :null => false
    t.string  "e_aprove_comment", :limit => 0, :null => false
  end

  create_table "configurations", :force => true do |t|
    t.string   "configuration_label",  :limit => 100
    t.string   "configuration_option", :limit => 100
    t.string   "configuration_value",  :limit => 100
    t.datetime "created_at"
  end

  create_table "contact_us", :force => true do |t|
    t.string "first_name", :null => false
    t.string "last_name"
    t.string "subject"
    t.text   "message",    :null => false
    t.string "country"
    t.string "zip"
    t.string "phone_no"
    t.string "mobile_no"
    t.string "email",      :null => false
  end

  create_table "content_paths", :force => true do |t|
    t.string "content_path",              :default => "http://content.holdmymemories.com", :null => false
    t.string "proxyname",                 :default => "http://www.holdmymemories.com"
    t.string "scp_path",                                                                   :null => false
    t.string "status",       :limit => 0, :default => "active",                            :null => false
  end

  create_table "contest_details", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "load_method_data"
    t.string   "css_file"
    t.string   "parse_id"
    t.text     "rules_regulations"
    t.text     "terms_conditions"
    t.date     "start_date"
    t.date     "vote_expire_date"
    t.date     "entry_end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contest_shares", :force => true do |t|
    t.string   "share_type", :limit => 0, :default => "email", :null => false
    t.integer  "contest_id", :limit => 8,                      :null => false
    t.string   "shared_by"
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
  end

  create_table "contest_votes", :force => true do |t|
    t.integer "uid",          :limit => 8,                      :null => false
    t.integer "contest_id",   :limit => 8,                      :null => false
    t.string  "email_id"
    t.integer "hmm_voter_id", :limit => 8
    t.date    "vote_date",                                      :null => false
    t.string  "unid"
    t.string  "conformed",    :limit => 0, :default => "no",    :null => false
    t.string  "method",       :limit => 0, :default => "email", :null => false
  end

  create_table "contestants", :force => true do |t|
    t.integer  "contest_id",      :limit => 8,                        :null => false
    t.string   "name",                                                :null => false
    t.integer  "user_content_id", :limit => 8,                        :null => false
    t.integer  "blog_id",         :limit => 8,                        :null => false
    t.integer  "votes",           :limit => 8,                        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status",          :limit => 0, :default => "pending", :null => false
  end

  create_table "contests", :force => true do |t|
    t.integer  "uid",                :limit => 8,                        :null => false
    t.integer  "moment_id",          :limit => 8,                        :null => false
    t.integer  "journal_id",         :limit => 8
    t.integer  "blog_id"
    t.string   "updated",            :limit => 0, :default => "no",      :null => false
    t.string   "moment_type",        :limit => 0,                        :null => false
    t.string   "contest_title",                                          :null => false
    t.string   "first_name"
    t.datetime "contest_entry_date"
    t.integer  "votes",              :limit => 8, :default => 0
    t.integer  "new_votes",          :limit => 8, :default => 0
    t.string   "status",             :limit => 0, :default => "pending", :null => false
    t.string   "age_groups",         :limit => 0
    t.string   "contest_phase",                   :default => "phase1",  :null => false
  end

  create_table "credit_facebook_counts", :force => true do |t|
    t.integer  "hmm_user_id", :limit => 8,                             :null => false
    t.string   "like_from",   :limit => 0, :default => "credit_point", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "credit_logs", :force => true do |t|
    t.integer  "credit_point_id", :null => false
    t.integer  "hmm_studio_id",   :null => false
    t.integer  "used_credit"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "credit_points", :force => true do |t|
    t.integer  "user_id",                                                     :null => false
    t.integer  "hmm_studiogroup_id",                                          :null => false
    t.float    "available_credits",        :limit => 10, :default => 0.0,     :null => false
    t.float    "used_credits",             :limit => 10, :default => 0.0,     :null => false
    t.text     "notes",                                                       :null => false
    t.float    "new_available_credits",    :limit => 10, :default => 0.0,     :null => false
    t.float    "old_available_credits",    :limit => 10, :default => 0.0,     :null => false
    t.float    "latest_available_credits", :limit => 10, :default => 0.0,     :null => false
    t.string   "mail_status",              :limit => 0,  :default => "false", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cupons", :force => true do |t|
    t.string   "unid",                      :null => false
    t.string   "valid_period",              :null => false
    t.datetime "start_date",                :null => false
    t.datetime "expire_date",               :null => false
    t.string   "cupon_type",   :limit => 0, :null => false
  end

  create_table "discount_coupons", :force => true do |t|
    t.integer  "studio_id",                                          :null => false
    t.string   "coupon_id",                                          :null => false
    t.integer  "print_size_id",                                      :null => false
    t.string   "coupon_title",                                       :null => false
    t.string   "size_label",                                         :null => false
    t.string   "discount",      :limit => 100, :default => "0.000",  :null => false
    t.string   "min_purchase",  :limit => 0,   :default => "No"
    t.float    "min_amount",    :limit => 10
    t.date     "start_date",                                         :null => false
    t.date     "end_date",                                           :null => false
    t.string   "status",        :limit => 0,   :default => "active", :null => false
    t.datetime "created_at",                                         :null => false
    t.datetime "modified_at"
  end

  add_index "discount_coupons", ["id"], :name => "id", :unique => true
  add_index "discount_coupons", ["id"], :name => "id_2", :unique => true

  create_table "discount_coupons_studios", :force => true do |t|
    t.integer "discount_coupon_id",               :null => false
    t.string  "studio_id",          :limit => 11, :null => false
    t.date    "created_at",                       :null => false
    t.date    "updated_at",                       :null => false
  end

  create_table "discount_offers", :force => true do |t|
    t.string   "email_address", :null => false
    t.string   "first_name",    :null => false
    t.string   "last_name",     :null => false
    t.integer  "contact_no",    :null => false
    t.string   "codes",         :null => false
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "discount_unsubscibes", :force => true do |t|
    t.integer  "hmm_user_id", :null => false
    t.integer  "coupon_id",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ecommerce_coupons", :force => true do |t|
    t.string  "coupon_id",                                          :null => false
    t.integer "discount"
    t.string  "free_shipping",   :limit => 0, :default => "false",  :null => false
    t.date    "start_date",                                         :null => false
    t.date    "end_date",                                           :null => false
    t.integer "studio_owner_id",                                    :null => false
    t.string  "status",          :limit => 0, :default => "active", :null => false
    t.date    "created_at",                                         :null => false
    t.date    "updated_at",                                         :null => false
  end

  create_table "ecommerce_coupons_studios", :force => true do |t|
    t.integer "ecommerce_coupon_id", :null => false
    t.integer "studio_id",           :null => false
    t.date    "created_at",          :null => false
    t.date    "updated_at",          :null => false
  end

  create_table "email_managements", :force => true do |t|
    t.string "from_email",                  :default => "admin@holdmymemories.com", :null => false
    t.string "to_email",                                                            :null => false
    t.text   "subject"
    t.text   "message"
    t.text   "footer_message"
    t.string "email_interval", :limit => 0,                                         :null => false
    t.string "file_name"
    t.string "email_type",     :limit => 0
  end

  create_table "employe_accounts", :force => true do |t|
    t.string   "employe_name",                                              :null => false
    t.string   "employe_username",                                          :null => false
    t.string   "password",                                                  :null => false
    t.string   "employe_id",                                                :null => false
    t.string   "branch"
    t.integer  "store_id",              :limit => 8
    t.string   "emp_type",              :limit => 0
    t.integer  "customer_count"
    t.string   "e_mail",                                                    :null => false
    t.string   "address",                                                   :null => false
    t.string   "phone_no",                                                  :null => false
    t.string   "emp_image"
    t.string   "status",                :limit => 0, :default => "unblock", :null => false
    t.datetime "employee_updated_date"
    t.date     "employe_join_date"
    t.date     "end_date"
  end

  create_table "exports", :force => true do |t|
    t.integer "exported_from",                :null => false
    t.integer "exported_to",                  :null => false
    t.string  "exported_id",   :limit => 256, :null => false
    t.string  "export_type",   :limit => 0,   :null => false
    t.string  "status",        :limit => 0,   :null => false
    t.string  "message"
  end

  create_table "failed_transactions", :force => true do |t|
    t.string   "subscriptionID",                    :null => false
    t.string   "subscriptionStatus", :limit => 200, :null => false
    t.string   "payment",            :limit => 150, :null => false
    t.integer  "totalRecurrences",   :limit => 8,   :null => false
    t.string   "transactionID",      :limit => 200, :null => false
    t.string   "amount",             :limit => 100, :null => false
    t.string   "currency",           :limit => 100, :null => false
    t.string   "method",             :limit => 200, :null => false
    t.string   "custFirstName",                     :null => false
    t.string   "custLastName",                      :null => false
    t.string   "respCode",                          :null => false
    t.text     "respText",                          :null => false
    t.datetime "transdate",                         :null => false
  end

  create_table "family_friends", :force => true do |t|
    t.integer "uid",                                              :null => false
    t.integer "fid",                                              :null => false
    t.integer "fnf_category", :limit => 8
    t.string  "status",       :limit => 0, :default => "pending", :null => false
    t.string  "block_status", :limit => 0, :default => "unblock", :null => false
  end

  create_table "family_members", :force => true do |t|
    t.integer "uid",               :limit => 8,                                                         :null => false
    t.integer "chap_id",           :limit => 8,                                                         :null => false
    t.string  "familymember_name",                                                                      :null => false
    t.string  "relation",                                                                               :null => false
    t.date    "bdate"
    t.text    "biographie"
    t.string  "member_image"
    t.string  "img_url",                        :default => "http://stagingcontent.holdmymemories.com"
  end

  create_table "familywebsite_shares", :force => true do |t|
    t.string   "family_website"
    t.string   "senders_email"
    t.string   "senders_name"
    t.string   "reciepent_emails"
    t.text     "share_message"
    t.integer  "website_owner_id", :limit => 8
    t.datetime "share_date"
  end

  create_table "familywebsite_themes", :force => true do |t|
    t.string   "theme_preferednames"
    t.string   "theme_name",                                             :null => false
    t.string   "tooltip_message"
    t.datetime "theme_added_date",                                       :null => false
    t.string   "theme_image"
    t.string   "status",              :limit => 0, :default => "active", :null => false
    t.integer  "re_order"
  end

  create_table "familywebsite_visits", :force => true do |t|
    t.integer  "uid",                 :limit => 8, :null => false
    t.string   "family_website_name",              :null => false
    t.datetime "visit_date",                       :null => false
  end

  create_table "faqs", :force => true do |t|
    t.text "question", :null => false
    t.text "answer",   :null => false
    t.date "fromdate"
    t.date "todate"
  end

  create_table "feed_updates", :force => true do |t|
    t.string  "feed_type", :limit => 0,                :null => false
    t.integer "cnt",                    :default => 0, :null => false
  end

  create_table "flash_video_images", :force => true do |t|
    t.integer  "flash_videos_id",  :null => false
    t.integer  "user_contents_id", :null => false
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "flash_videos", :force => true do |t|
    t.integer  "gallery_id",                                       :null => false
    t.string   "name",                                             :null => false
    t.string   "audio",      :default => "default_flashaudio.mp3", :null => false
    t.datetime "created_at",                                       :null => false
    t.datetime "updated_at",                                       :null => false
  end

  create_table "flex_comments", :force => true do |t|
    t.string   "component_name", :null => false
    t.string   "type",           :null => false
    t.text     "comment",        :null => false
    t.datetime "created_at"
    t.datetime "modified_at"
  end

  create_table "fnf_groups", :force => true do |t|
    t.string  "fnf_category", :null => false
    t.integer "uid",          :null => false
  end

  create_table "galleries", :force => true do |t|
    t.string   "v_gallery_name"
    t.string   "e_gallery_type",    :limit => 0
    t.datetime "d_gallery_date",                                                                           :null => false
    t.string   "status",            :limit => 0,   :default => "active",                                   :null => false
    t.string   "e_gallery_acess",   :limit => 0
    t.string   "v_gallery_image",                  :default => "image.png"
    t.integer  "subchapter_id",     :limit => 8,                                                           :null => false
    t.text     "permissions"
    t.string   "v_gallery_tags",    :limit => 512, :default => "Add Tags Here",                            :null => false
    t.string   "v_desc",            :limit => 512, :default => "Enter Description Here",                   :null => false
    t.string   "img_url",                          :default => "http://stagingcontent.holdmymemories.com"
    t.datetime "deleted_date"
    t.integer  "order_num",                        :default => 0,                                          :null => false
    t.integer  "old_subchapter_id", :limit => 8,   :default => 0,                                          :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "auto_share",                       :default => false,                                      :null => false
    t.string   "client",            :limit => 0,   :default => "website",                                  :null => false
    t.boolean  "facebook_share",                   :default => false,                                      :null => false
  end

  create_table "gallery_comments", :force => true do |t|
    t.integer  "uid",          :limit => 8,                          :null => false
    t.integer  "gallery_id",   :limit => 8,                          :null => false
    t.integer  "gallery_jid",  :limit => 8,                          :null => false
    t.string   "v_name"
    t.text     "v_comment",                                          :null => false
    t.datetime "d_created_on",                                       :null => false
    t.string   "e_approval",   :limit => 0,   :default => "pending", :null => false
    t.string   "ctype",        :limit => 250, :default => "gallery", :null => false
    t.string   "reply"
  end

  create_table "gallery_journals", :force => true do |t|
    t.integer  "uid",          :limit => 8,                        :null => false
    t.integer  "galerry_id",   :limit => 8,                        :null => false
    t.string   "v_title",                                          :null => false
    t.text     "v_journal",                                        :null => false
    t.datetime "d_created_on",                                     :null => false
    t.datetime "d_updated_on",                                     :null => false
    t.string   "jtype",                     :default => "gallery", :null => false
  end

  create_table "gift_coupons", :force => true do |t|
    t.string   "gift_type",       :limit => 0,   :null => false
    t.float    "amount",          :limit => 6,   :null => false
    t.integer  "months",          :limit => 8,   :null => false
    t.string   "street_address",                 :null => false
    t.string   "city",                           :null => false
    t.string   "state",                          :null => false
    t.string   "zipcode",                        :null => false
    t.string   "telephone",                      :null => false
    t.string   "email_id",                       :null => false
    t.string   "firstname",                      :null => false
    t.string   "lastname",                       :null => false
    t.string   "recipient_name",  :limit => 100
    t.string   "gifted_to_email"
    t.string   "message"
    t.integer  "gift_user",       :limit => 8
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "unid"
  end

  create_table "guest_comments", :force => true do |t|
    t.integer  "uid",            :limit => 8,                        :null => false
    t.integer  "journal_typeid", :limit => 8,                        :null => false
    t.integer  "journal_id",     :limit => 8,                        :null => false
    t.string   "journal_type",                                       :null => false
    t.string   "name",                                               :null => false
    t.text     "comment",                                            :null => false
    t.datetime "comment_date",                                       :null => false
    t.string   "ctype",                                              :null => false
    t.string   "status",         :limit => 0, :default => "pending", :null => false
  end

  create_table "guestbook_comment_captchas", :force => true do |t|
    t.string   "value",      :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "hmm_contest_votes", :force => true do |t|
    t.integer  "contestant_id", :limit => 8,                        :null => false
    t.integer  "voter_id",      :limit => 8,                        :null => false
    t.string   "email",                                             :null => false
    t.string   "unique_id",                                         :null => false
    t.string   "status",        :limit => 0, :default => "pending", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "hmm_contests", :force => true do |t|
    t.string   "contest_type",  :limit => 0,                                                        :null => false
    t.string   "title",                                                                             :null => false
    t.text     "description"
    t.text     "prizes",                                                                            :null => false
    t.text     "rules"
    t.string   "presented_by",                                                                      :null => false
    t.text     "terms",                                                                             :null => false
    t.string   "logo",                                                                              :null => false
    t.string   "img_url",                    :default => "http://contentbackup.holdmymemories.com", :null => false
    t.string   "status",        :limit => 0, :default => "active",                                  :null => false
    t.integer  "contestant_id", :limit => 8
    t.datetime "start_date",                                                                        :null => false
    t.datetime "end_date",                                                                          :null => false
    t.datetime "created_at",                                                                        :null => false
    t.datetime "updated_at",                                                                        :null => false
  end

  create_table "hmm_studiogroups", :force => true do |t|
    t.string   "studiogroup_username",                                            :null => false
    t.string   "password",                                                        :null => false
    t.string   "hmm_franchise_studio"
    t.string   "street"
    t.string   "city",                      :limit => 100
    t.integer  "state_id",                                 :default => 0
    t.string   "zipcode",                   :limit => 100
    t.string   "country",                   :limit => 100
    t.string   "website",                   :limit => 100
    t.string   "studio_phone",              :limit => 100
    t.string   "contact_name",              :limit => 100
    t.string   "contact_email",             :limit => 100
    t.string   "contact_phone",             :limit => 100
    t.string   "studio_taxnumber",          :limit => 100
    t.string   "studio_logo",               :limit => 100
    t.string   "children",                  :limit => 0,   :default => "no"
    t.string   "family",                    :limit => 0,   :default => "no"
    t.string   "maternity",                 :limit => 0,   :default => "no"
    t.string   "glamour",                   :limit => 0,   :default => "no"
    t.string   "high_school_seniors",       :limit => 0,   :default => "no"
    t.string   "bridal",                    :limit => 0,   :default => "no"
    t.string   "weddings",                  :limit => 0,   :default => "no"
    t.string   "other_session"
    t.string   "watermark",                 :limit => 0,   :default => "no"
    t.string   "free_sessions",             :limit => 0,   :default => "no"
    t.string   " studio_package_discounts", :limit => 0,   :default => "no"
    t.integer  " percentage_discount",                     :default => 0
    t.string   "free_print",                :limit => 0,   :default => "no"
    t.string   "free_video",                :limit => 0,   :default => "no"
    t.string   "free_card",                 :limit => 0,   :default => "no"
    t.string   "other_benefit",             :limit => 100
    t.string   "credit_system",             :limit => 0,   :default => "Dollars", :null => false
    t.datetime "date_joined"
    t.string   "status",                    :limit => 0,   :default => "active",  :null => false
    t.datetime "created_at"
  end

  create_table "hmm_studios", :force => true do |t|
    t.integer "studio_groupid",           :limit => 8
    t.string  "studio_branch"
    t.string  "studio_name"
    t.text    "studio_address"
    t.string  "street"
    t.string  "city"
    t.integer "state_id",                                :default => 0
    t.string  "zip_code",                 :limit => 100
    t.string  "country"
    t.string  "studio_website"
    t.string  "studio_phone",             :limit => 100
    t.string  "contact_name",             :limit => 100
    t.string  "contact_email",            :limit => 100
    t.string  "contact_phone",            :limit => 100
    t.string  "studio_taxnumber",         :limit => 100
    t.string  "studio_logo",              :limit => 100
    t.string  "studio_top_logo",          :limit => 100
    t.string  "studio_button_logo",       :limit => 100
    t.string  "children",                 :limit => 0,   :default => "no"
    t.string  "family",                   :limit => 0,   :default => "no"
    t.string  "maternity",                :limit => 0,   :default => "no"
    t.string  "glamour",                  :limit => 0,   :default => "no"
    t.string  "high_school_seniors",      :limit => 0,   :default => "no"
    t.string  "bridal",                   :limit => 0,   :default => "no"
    t.string  "weddings",                 :limit => 0,   :default => "no"
    t.string  "other_session"
    t.string  "watermark",                :limit => 0,   :default => "no"
    t.string  "free_sessions",            :limit => 0,   :default => "no"
    t.string  "studio_package_discounts", :limit => 0,   :default => "no"
    t.integer "percentage_discount",                     :default => 0
    t.string  "free_print",               :limit => 0,   :default => "no"
    t.string  "free_video",               :limit => 0,   :default => "no"
    t.string  "free_card",                :limit => 0,   :default => "no"
    t.string  "other_benefit",            :limit => 100
    t.string  "status",                   :limit => 0,   :default => "active",                                    :null => false
    t.string  "credit_option",            :limit => 0,   :default => "no",                                        :null => false
    t.integer "credit_percentage"
    t.string  "print_order",              :limit => 0,   :default => "hmm"
    t.float   "tax_rate",                 :limit => 10,  :default => 0.0
    t.text    "description"
    t.string  "mobile_studio_logo",       :limit => 100
    t.string  "aboutus_image",            :limit => 100
    t.string  "img_url",                                 :default => "http://stagingcontent1.holdmymemories.com", :null => false
    t.integer "family_website_version"
    t.string  "studiobt_status",          :limit => 0,   :default => "active",                                    :null => false
  end

  create_table "hmm_users", :force => true do |t|
    t.string   "v_fname",                                                                                           :null => false
    t.string   "v_lname",                                                                                           :null => false
    t.string   "e_sex",                     :limit => 10,                                                           :null => false
    t.string   "marital_status",            :limit => 0,   :default => "married"
    t.string   "v_user_name",                                                                                       :null => false
    t.string   "v_password",                                                                                        :null => false
    t.string   "v_add1"
    t.string   "v_add2"
    t.string   "v_city",                    :limit => 100
    t.string   "v_state",                   :limit => 100
    t.string   "v_country",                 :limit => 100,                                                          :null => false
    t.string   "v_zip",                     :limit => 100,                                                          :null => false
    t.string   "v_e_mail",                  :limit => 100,                                                          :null => false
    t.string   "e_user_status",             :limit => 0,   :default => "unblocked",                                 :null => false
    t.integer  "i_ip_add"
    t.integer  "i_login_status"
    t.datetime "d_created_date",                                                                                    :null => false
    t.datetime "d_updated_date",                                                                                    :null => false
    t.date     "d_bdate",                                                                                           :null => false
    t.string   "v_myimage",                 :limit => 100, :default => "blank.jpg"
    t.string   "v_security_q",              :limit => 256,                                                          :null => false
    t.string   "v_security_a",              :limit => 256,                                                          :null => false
    t.text     "v_abt_me"
    t.string   "v_link1"
    t.string   "v_link2"
    t.string   "v_link3"
    t.string   "knowhmm"
    t.string   "refral"
    t.string   "family_name"
    t.string   "family_header",                            :default => "Welcome to:",                               :null => false
    t.string   "familyname_select"
    t.string   "family_footer",                            :default => "Family Website",                            :null => false
    t.string   "family_pic",                               :default => "defaultfamily.jpg"
    t.text     "about_family"
    t.text     "family_history"
    t.string   "familypage_image"
    t.string   "familyheader_image"
    t.string   "familyfooter_image"
    t.string   "familywebsite_password"
    t.string   "password_required",         :limit => 0,   :default => "no",                                        :null => false
    t.string   "upload_type",               :limit => 0,   :default => "basic",                                     :null => false
    t.string   "img_url",                                  :default => "http://stagingcontent1.holdmymemories.com"
    t.text     "street_address"
    t.string   "suburb"
    t.string   "postcode",                  :limit => 50
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "telephone"
    t.string   "fax"
    t.string   "account_type",              :limit => 0,   :default => "free_user",                                 :null => false
    t.integer  "emp_id",                    :limit => 8
    t.string   "unid"
    t.date     "account_expdate"
    t.string   "subscriptionnumber"
    t.string   "invoicenumber"
    t.string   "months"
    t.string   "amount"
    t.string   "substatus",                 :limit => 0,   :default => "active"
    t.datetime "suspended_date"
    t.string   "cupon_no"
    t.text     "cancel_reason"
    t.string   "cancel_status",             :limit => 0
    t.datetime "cancellation_request_date"
    t.integer  "canceled_by",               :limit => 8
    t.integer  "payments_recieved",         :limit => 8,   :default => 1
    t.string   "alt_family_name"
    t.datetime "billed_date"
    t.string   "billed_status",             :limit => 0
    t.string   "msg",                       :limit => 0,   :default => "0",                                         :null => false
    t.integer  "themes_id",                                :default => 1,                                           :null => false
    t.string   "themes",                                   :default => "myfamilywebsite",                           :null => false
    t.string   "membership_sold_by"
    t.string   "terms_checked",             :limit => 0,   :default => "false"
    t.integer  "theme_id",                                 :default => 1,                                           :null => false
    t.string   "gift_coupon_id",            :limit => 100
    t.string   "process",                   :limit => 250
    t.integer  "studio_id",                 :limit => 8,   :default => 0,                                           :null => false
    t.text     "notes_link_to_customer"
    t.text     "reactivated_admin"
    t.integer  "facebook_profile_id",       :limit => 8,   :default => 0,                                           :null => false
    t.text     "studio_management_notes"
    t.text     "studio_manager_notes"
    t.integer  "old_emp_id"
    t.integer  "old_studio_id"
    t.string   "client",                    :limit => 0,   :default => "website",                                   :null => false
    t.date     "first_payment_date"
    t.string   "facebook_connect_id"
  end

  create_table "hmm_users_past_studios", :force => true do |t|
    t.integer  "uid",         :limit => 8, :null => false
    t.integer  "past_studio", :limit => 8, :null => false
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  create_table "hmm_users_tests", :force => true do |t|
    t.string   "v_fname",                                                                                   :null => false
    t.string   "v_lname",                                                                                   :null => false
    t.string   "e_sex",                     :limit => 10,                                                   :null => false
    t.string   "marital_status",            :limit => 0,   :default => "married"
    t.string   "v_user_name",                                                                               :null => false
    t.string   "v_password",                                                                                :null => false
    t.string   "v_add1"
    t.string   "v_add2"
    t.string   "v_city",                    :limit => 100
    t.string   "v_state",                   :limit => 100
    t.string   "v_country",                 :limit => 100,                                                  :null => false
    t.string   "v_zip",                     :limit => 100,                                                  :null => false
    t.string   "v_e_mail",                  :limit => 100,                                                  :null => false
    t.string   "e_user_status",             :limit => 0,   :default => "unblocked",                         :null => false
    t.integer  "i_ip_add"
    t.integer  "i_login_status"
    t.datetime "d_created_date",                                                                            :null => false
    t.datetime "d_updated_date",                                                                            :null => false
    t.date     "d_bdate",                                                                                   :null => false
    t.string   "v_myimage",                 :limit => 100, :default => "blank.jpg"
    t.string   "v_security_q",              :limit => 256,                                                  :null => false
    t.string   "v_security_a",              :limit => 256,                                                  :null => false
    t.text     "v_abt_me"
    t.string   "v_link1"
    t.string   "v_link2"
    t.string   "v_link3"
    t.string   "knowhmm"
    t.string   "refral"
    t.string   "family_name"
    t.string   "family_header",                            :default => "Welcome to:",                       :null => false
    t.string   "familyname_select"
    t.string   "family_footer",                            :default => "Family Website",                    :null => false
    t.string   "family_pic",                               :default => "defaultfamily.jpg"
    t.text     "about_family"
    t.text     "family_history"
    t.string   "familypage_image"
    t.string   "familyheader_image"
    t.string   "familyfooter_image"
    t.string   "familywebsite_password"
    t.string   "password_required",         :limit => 0,   :default => "no",                                :null => false
    t.string   "upload_type",               :limit => 0,   :default => "basic",                             :null => false
    t.string   "img_url",                                  :default => "http://content.holdmymemories.com"
    t.text     "street_address"
    t.string   "suburb"
    t.string   "postcode",                  :limit => 50
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "telephone"
    t.string   "fax"
    t.string   "account_type",              :limit => 0,   :default => "free_user",                         :null => false
    t.integer  "emp_id",                    :limit => 8
    t.string   "unid"
    t.date     "account_expdate"
    t.string   "subscriptionnumber"
    t.string   "invoicenumber"
    t.string   "months"
    t.string   "amount"
    t.string   "substatus",                 :limit => 0,   :default => "active"
    t.datetime "suspended_date"
    t.string   "cupon_no"
    t.text     "cancel_reason"
    t.string   "cancel_status",             :limit => 0
    t.date     "cancellation_request_date"
    t.integer  "canceled_by",               :limit => 8
    t.integer  "payments_recieved",         :limit => 8,   :default => 1
    t.string   "alt_family_name"
    t.datetime "billed_date"
    t.string   "billed_status",             :limit => 0
    t.string   "msg",                       :limit => 0,   :default => "0",                                 :null => false
    t.datetime "first_payment_date"
    t.string   "membership_sold_by"
    t.string   "themes",                    :limit => 0,   :default => "myfamilywebsite"
    t.string   "terms_checked",             :limit => 0,   :default => "false"
    t.integer  "theme_id",                                 :default => 1,                                   :null => false
    t.integer  "comission_month",           :limit => 8,   :default => 0
    t.string   "process",                   :limit => 250, :default => "no"
  end

  create_table "hmms", :force => true do |t|
    t.string   "fname",                                                :null => false
    t.string   "lname",                                                :null => false
    t.string   "user_name",                                            :null => false
    t.string   "password",                                             :null => false
    t.string   "add1",                                                 :null => false
    t.string   "add2",                                                 :null => false
    t.string   "city",         :limit => 100,                          :null => false
    t.string   "state",        :limit => 100,                          :null => false
    t.string   "country",      :limit => 100,                          :null => false
    t.integer  "zip",                                                  :null => false
    t.string   "e-mail",       :limit => 100,                          :null => false
    t.string   "user_status",  :limit => 0,   :default => "unblocked", :null => false
    t.integer  "ip_add",                                               :null => false
    t.boolean  "login_status",                                         :null => false
    t.datetime "created_date",                                         :null => false
    t.datetime "updated_date",                                         :null => false
  end

  create_table "iapp_transactions", :force => true do |t|
    t.integer  "uid",                         :limit => 8,                         :null => false
    t.string   "product_id"
    t.string   "transaction_id"
    t.datetime "purchase_date"
    t.string   "original_transaction_id"
    t.datetime "original_purchase_date"
    t.string   "version_external_identifier"
    t.string   "bid"
    t.string   "bvrs"
    t.string   "transaction_type",            :limit => 0, :default => "free_app", :null => false
  end

  create_table "invite_friends", :force => true do |t|
    t.text    "friends_email",              :null => false
    t.integer "uid",           :limit => 8, :null => false
  end

  create_table "iphone_aboutus_studio_logos", :force => true do |t|
    t.integer  "studio_id",                                                            :null => false
    t.string   "mobile_studio_logo"
    t.string   "aboutus_image"
    t.text     "description"
    t.string   "logo_img_url",       :default => "http://content1.holdmymemories.com"
    t.string   "about_us_img_url",   :default => "http://content1.holdmymemories.com"
    t.datetime "created_at"
    t.datetime "modified_at"
  end

  create_table "journals", :force => true do |t|
    t.integer  "uid",                 :limit => 8
    t.integer  "chap_id",             :limit => 8
    t.string   "v_title",                          :null => false
    t.string   "v_small_description",              :null => false
    t.text     "v_large_description",              :null => false
    t.datetime "d_create_date",                    :null => false
    t.datetime "d_updated_date",                   :null => false
    t.string   "e_journal_access",    :limit => 0, :null => false
    t.datetime "d_reminder_date"
  end

  create_table "journals_audios", :force => true do |t|
    t.string "v_audio_filename", :limit => 256, :null => false
    t.string "v_audio_comment",  :limit => 256
  end

  create_table "journals_comments", :force => true do |t|
    t.string   "v_title",          :limit => 256, :null => false
    t.datetime "v_comment",                       :null => false
    t.datetime "d_added_date",                    :null => false
    t.string   "v_comment_by",     :limit => 256, :null => false
    t.string   "v_email_id",       :limit => 256, :null => false
    t.string   "e_friend_request", :limit => 0,   :null => false
  end

  create_table "journals_paperworks", :force => true do |t|
    t.string "v_paper_filename", :limit => 256, :null => false
    t.string "v_comment",        :limit => 256
  end

  create_table "journals_photos", :force => true do |t|
    t.integer  "user_content_id", :limit => 8,                      :null => false
    t.string   "v_title"
    t.text     "v_image_comment"
    t.text     "Comment_from"
    t.string   "approved",        :limit => 0, :default => "no"
    t.datetime "date_added",                                        :null => false
    t.string   "jtype",                        :default => "photo", :null => false
    t.datetime "updated_date"
  end

  create_table "journals_videos", :force => true do |t|
    t.string  "v_video_filename", :limit => 256, :null => false
    t.string  "v_comment",        :limit => 256
    t.integer "i_video_width"
    t.integer "i_video_height"
    t.integer "i_video_x"
    t.integer "i_video_y"
  end

  create_table "manager_branches", :force => true do |t|
    t.integer "manager_id", :limit => 8,                           :null => false
    t.integer "branch_id",  :limit => 8,                           :null => false
    t.date    "expired_on",              :default => '2099-01-01'
    t.date    "joined_on",               :default => '2009-01-01'
  end

  create_table "market_managers", :force => true do |t|
    t.string "manager_name",                                         :null => false
    t.string "manager_username",                                     :null => false
    t.string "password",                                             :null => false
    t.string "employee_id",                                          :null => false
    t.string "e_mail",                                               :null => false
    t.text   "address",                                              :null => false
    t.string "phone_no",                                             :null => false
    t.string "status",           :limit => 0, :default => "unblock", :null => false
  end

  create_table "memories_count", :force => true do |t|
    t.integer  "usercontent_id", :limit => 8,                :null => false
    t.string   "content_type",   :limit => 0,                :null => false
    t.integer  "user_id",        :limit => 8, :default => 0, :null => false
    t.string   "view_type",      :limit => 0,                :null => false
    t.datetime "view_date",                                  :null => false
  end

  create_table "message_boards", :force => true do |t|
    t.integer  "uid",         :limit => 8,                                                         :null => false
    t.string   "title"
    t.string   "subject",                                                                          :null => false
    t.text     "message",                                                                          :null => false
    t.string   "guest_name",                                                                       :null => false
    t.string   "email",                                                                            :null => false
    t.string   "guest_image"
    t.datetime "created_at",                                                                       :null => false
    t.datetime "updated_on",                                                                       :null => false
    t.text     "reply"
    t.string   "status",      :limit => 0, :default => "pending",                                  :null => false
    t.string   "ctype",                    :default => "message_boards",                           :null => false
    t.string   "img_url",                  :default => "http://stagingcontent.holdmymemories.com"
  end

  create_table "mobile_blog_contents", :force => true do |t|
    t.string   "file_name",                                                                      :null => false
    t.string   "server_url",              :default => "http://contentbackup.holdmymemories.com", :null => false
    t.string   "file_type",  :limit => 0, :default => "image",                                   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mobile_content_shares", :force => true do |t|
    t.text     "user_contents", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mobile_journals", :force => true do |t|
    t.integer  "user_id",                                         :null => false
    t.string   "title",                                           :null => false
    t.text     "description",                                     :null => false
    t.string   "source"
    t.string   "journal_type", :limit => 0,                       :null => false
    t.string   "audio_tag"
    t.string   "content_url"
    t.date     "journal_date",                                    :null => false
    t.string   "status",       :limit => 0, :default => "active", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mobile_shares", :force => true do |t|
    t.integer  "subchapter_id",                  :null => false
    t.string   "subchapter_type", :limit => 0,   :null => false
    t.string   "email",           :limit => 100, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "my_carts", :force => true do |t|
    t.integer "uid",           :limit => 8,                        :null => false
    t.string  "added_item",    :limit => 0,                        :null => false
    t.integer "moment_id",     :limit => 8,                        :null => false
    t.string  "status",        :limit => 0, :default => "pending", :null => false
    t.integer "no_of_copies",               :default => 1,         :null => false
    t.integer "no_of_moments"
    t.integer "price"
    t.string  "product_id"
  end

  create_table "nonhmm_users", :force => true do |t|
    t.integer "uid"
    t.string  "v_name",                   :null => false
    t.string  "v_email",                  :null => false
    t.string  "v_city"
    t.string  "v_country"
    t.string  "v_status"
    t.text    "v_street"
    t.string  "v_phone",   :limit => 100
  end

  create_table "order_details", :force => true do |t|
    t.integer  "uid",              :limit => 8,                   :null => false
    t.string   "order_unid",                                      :null => false
    t.string   "moment_type",      :limit => 0
    t.integer  "moment_id",        :limit => 8,                   :null => false
    t.integer  "no_of_copies",                                    :null => false
    t.string   "product_id"
    t.string   "payment_status",   :limit => 0, :default => "no", :null => false
    t.string   "order_status",     :limit => 0, :default => "no", :null => false
    t.string   "shippment_status", :limit => 0, :default => "no", :null => false
    t.string   "comments"
    t.datetime "order_date"
    t.datetime "shippment_date"
  end

  create_table "order_products", :force => true do |t|
    t.integer  "order_id",                                           :null => false
    t.integer  "user_id"
    t.integer  "user_content_id",                                    :null => false
    t.string   "img_url",                                            :null => false
    t.string   "original_image",                                     :null => false
    t.string   "print_image",                                        :null => false
    t.integer  "quantity",                                           :null => false
    t.integer  "size_id",                                            :null => false
    t.float    "price",           :limit => 10,                      :null => false
    t.integer  "order_num",                     :default => 0
    t.text     "operations"
    t.string   "order_type",      :limit => 0,  :default => "print", :null => false
    t.datetime "created_at",                                         :null => false
    t.datetime "updated_at",                                         :null => false
    t.string   "ordered_by",      :limit => 0
    t.integer  "visitor_id"
  end

  create_table "order_request_statuses", :force => true do |t|
    t.integer  "owner_id"
    t.integer  "visitor_id"
    t.string   "status",     :limit => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "order_requests", :force => true do |t|
    t.integer  "owner_id"
    t.string   "email_address"
    t.text     "message"
    t.string   "requested_by"
    t.string   "status",        :limit => 0
    t.string   "request_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders", :force => true do |t|
    t.string   "order_number",        :limit => 100,                        :null => false
    t.integer  "user_id"
    t.integer  "studio_id"
    t.string   "shipping_name",       :limit => 64,                         :null => false
    t.string   "shipping_lname"
    t.string   "shipping_address",    :limit => 64,                         :null => false
    t.string   "shipping_city",       :limit => 32,                         :null => false
    t.string   "shipping_zip",        :limit => 10,                         :null => false
    t.string   "shipping_state",      :limit => 32
    t.string   "shipping_country",    :limit => 32,                         :null => false
    t.string   "shipping_phone",      :limit => 32,                         :null => false
    t.string   "shipping_email",      :limit => 100,                        :null => false
    t.string   "billing_name",        :limit => 64,                         :null => false
    t.string   "billing_lname"
    t.string   "billing_address",     :limit => 64,                         :null => false
    t.string   "billing_city",        :limit => 32,                         :null => false
    t.string   "billing_zip",         :limit => 10,                         :null => false
    t.string   "billing_state",       :limit => 32
    t.string   "billing_country",     :limit => 32,                         :null => false
    t.string   "billing_phone",       :limit => 25,                         :null => false
    t.string   "billing_email",       :limit => 100,                        :null => false
    t.string   "payment_method",                                            :null => false
    t.string   "cc_type",             :limit => 20
    t.string   "cc_owner",            :limit => 64
    t.string   "cc_number",           :limit => 32
    t.string   "cc_expires",          :limit => 4
    t.datetime "date_purchased"
    t.string   "orders_status",       :limit => 0,   :default => "pending", :null => false
    t.float    "total_price",         :limit => 10,                         :null => false
    t.float    "sales_tax",           :limit => 10,  :default => 0.0
    t.float    "tax_rate",            :limit => 10,  :default => 0.0
    t.float    "shipping_price",      :limit => 10,                         :null => false
    t.string   "shipping_method"
    t.integer  "process_studio_id",                  :default => 0,         :null => false
    t.integer  "order_group_id",                     :default => 0
    t.string   "status",              :limit => 0,   :default => "active"
    t.string   "download_order",      :limit => 0,   :default => "false",   :null => false
    t.integer  "ecommerce_coupon_id",                                       :null => false
    t.float    "discount_price",      :limit => 10,                         :null => false
    t.string   "free_shipping",       :limit => 0,   :default => "false",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ordered_by",          :limit => 0
    t.integer  "visitor_id"
  end

  create_table "pages", :force => true do |t|
    t.string   "title"
    t.string   "permalink",  :null => false
    t.text     "body"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "payment_counts", :force => true do |t|
    t.integer  "uid",             :limit => 8,                        :null => false
    t.string   "amount",                                              :null => false
    t.datetime "recieved_on",                                         :null => false
    t.string   "account_type",                                        :null => false
    t.integer  "emp_id",          :limit => 8
    t.string   "month",           :limit => 50
    t.string   "credit_status",   :limit => 0,  :default => "active", :null => false
    t.string   "credit_month"
    t.string   "cp_modification", :limit => 0,  :default => "active", :null => false
  end

  create_table "payment_details", :force => true do |t|
    t.integer  "user_id",                 :limit => 8,                        :null => false
    t.string   "order_id",                                                    :null => false
    t.string   "fname",                                                       :null => false
    t.string   "lname",                                                       :null => false
    t.integer  "amount",                                                      :null => false
    t.string   "street_address",                                              :null => false
    t.string   "city",                                                        :null => false
    t.string   "state",                                                       :null => false
    t.string   "country",                                                     :null => false
    t.string   "postcode",                                                    :null => false
    t.string   "telephone",                                                   :null => false
    t.string   "shipment_street_address",                                     :null => false
    t.string   "shipment_city",                                               :null => false
    t.string   "shipment_state",                                              :null => false
    t.string   "shipment_country",                                            :null => false
    t.string   "shipment_postcode",                                           :null => false
    t.string   "shipment_telephone",                                          :null => false
    t.string   "exp_month",                                                   :null => false
    t.string   "exp_year",                                                    :null => false
    t.datetime "order_date",                                                  :null => false
    t.datetime "shippment_date",                                              :null => false
    t.string   "order_process_status",    :limit => 0, :default => "pending", :null => false
    t.string   "shipment_status",         :limit => 0, :default => "pending", :null => false
  end

  create_table "payments_count", :force => true do |t|
    t.integer  "uid",          :limit => 8, :null => false
    t.string   "amount",                    :null => false
    t.datetime "recieved_on",               :null => false
    t.string   "account_type",              :null => false
  end

  create_table "photo_comments", :force => true do |t|
    t.integer  "uid",             :limit => 8
    t.integer  "journal_id",      :limit => 8
    t.string   "v_title"
    t.string   "v_name"
    t.integer  "v_uid",           :limit => 8
    t.string   "v_email"
    t.text     "v_comment"
    t.datetime "d_add_date",                                            :null => false
    t.string   "e_approved",      :limit => 0,   :default => "pending"
    t.string   "e_access",        :limit => 0,   :default => "private"
    t.integer  "user_content_id", :limit => 8,                          :null => false
    t.string   "ctype",           :limit => 250, :default => "moment",  :null => false
    t.string   "reply"
  end

  create_table "photobook_audios", :force => true do |t|
    t.integer  "uid"
    t.string   "audio_file"
    t.string   "audio_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "photobook_backgrounds", :force => true do |t|
    t.string   "background_image",                  :null => false
    t.integer  "photobook_layouts_id", :limit => 8, :null => false
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  create_table "photobook_borders", :force => true do |t|
    t.string   "border_image",                      :default => "http://contentbackup.holdmymemories.com/user_content/photobook_borders/", :null => false
    t.integer  "photobook_layouts_id", :limit => 8,                                                                                        :null => false
    t.datetime "created_at",                                                                                                               :null => false
    t.datetime "updated_at",                                                                                                               :null => false
  end

  create_table "photobook_images", :force => true do |t|
    t.integer "photobook_page_id",     :limit => 8,                                                      :null => false
    t.integer "photobook_id",          :limit => 8,                                                      :null => false
    t.integer "usercontent_id",        :limit => 8,                                                      :null => false
    t.decimal "x",                                  :precision => 8,  :scale => 7
    t.decimal "y",                                  :precision => 8,  :scale => 7
    t.decimal "width",                              :precision => 8,  :scale => 7
    t.decimal "height",                             :precision => 8,  :scale => 7
    t.decimal "rotation",                           :precision => 10, :scale => 7
    t.text    "image_path"
    t.string  "image_type",            :limit => 0,                                :default => "image",  :null => false
    t.float   "crop_x",                :limit => 8,                                :default => 0.0,      :null => false
    t.float   "crop_y",                :limit => 8,                                :default => 0.0,      :null => false
    t.float   "crop_height",           :limit => 8,                                :default => 1.0
    t.float   "crop_width",            :limit => 8,                                :default => 1.0
    t.string  "tint",                  :limit => 0,                                :default => "notint", :null => false
    t.string  "order"
    t.integer "photobook_template_id"
  end

  create_table "photobook_layouts", :force => true do |t|
    t.string   "layout_type",                :null => false
    t.integer  "height",                     :null => false
    t.string   "width",       :limit => 100, :null => false
    t.string   "icon",                       :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "modified_at"
  end

  create_table "photobook_pages", :force => true do |t|
    t.integer "photobook_id",     :limit => 8,                    :null => false
    t.integer "page_number",      :limit => 8,                    :null => false
    t.text    "page_image",                                       :null => false
    t.string  "background",       :limit => 0, :default => "yes", :null => false
    t.text    "background_image"
  end

  create_table "photobook_stickers", :force => true do |t|
    t.string   "sticker_image", :null => false
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "photobook_template_backgrounds", :force => true do |t|
    t.integer "template_id",      :limit => 8, :null => false
    t.text    "background_image",              :null => false
  end

  create_table "photobook_template_images", :force => true do |t|
    t.integer  "photobook_template_id",                                                                 :null => false
    t.integer  "image_count",                                                                           :null => false
    t.decimal  "desired_height",                     :precision => 10, :scale => 7,                     :null => false
    t.decimal  "desired_width",                      :precision => 10, :scale => 7,                     :null => false
    t.decimal  "x_shift",                            :precision => 10, :scale => 7,                     :null => false
    t.decimal  "y_shift",                            :precision => 10, :scale => 7,                     :null => false
    t.decimal  "x_scale",                            :precision => 10, :scale => 7,                     :null => false
    t.decimal  "y_scale",                            :precision => 10, :scale => 7,                     :null => false
    t.decimal  "rotation",                           :precision => 10, :scale => 8, :default => 0.0,    :null => false
    t.string   "scale_to_fit",          :limit => 0,                                :default => "true", :null => false
    t.integer  "type_id"
    t.datetime "created_at",                                                                            :null => false
    t.datetime "updated_at",                                                                            :null => false
  end

  create_table "photobook_templates", :force => true do |t|
    t.string   "name",                                         :null => false
    t.text     "image",                                        :null => false
    t.integer  "number_of_images",              :default => 1, :null => false
    t.string   "background_image",                             :null => false
    t.string   "border_image"
    t.integer  "width",            :limit => 3,                :null => false
    t.integer  "height",                                       :null => false
    t.integer  "type_id"
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
  end

  create_table "photobook_templates_masks", :force => true do |t|
    t.integer  "photobook_template_images_id",                                                                      :null => false
    t.decimal  "x",                                         :precision => 10, :scale => 7,                          :null => false
    t.decimal  "y",                                         :precision => 10, :scale => 7,                          :null => false
    t.decimal  "height",                                    :precision => 10, :scale => 7,                          :null => false
    t.decimal  "width",                                     :precision => 10, :scale => 7,                          :null => false
    t.decimal  "rotation",                                  :precision => 10, :scale => 8, :default => 0.0,         :null => false
    t.string   "mask_type",                    :limit => 0,                                :default => "rectangle", :null => false
    t.datetime "created_at",                                                                                        :null => false
    t.datetime "modified_at"
  end

  create_table "photobooks", :force => true do |t|
    t.string  "title",                              :null => false
    t.string  "photobook_icon"
    t.integer "uid",                   :limit => 8, :null => false
    t.integer "photobook_audio_id"
    t.integer "width",                              :null => false
    t.integer "height",                             :null => false
    t.integer "type_id",                            :null => false
    t.text    "description"
    t.integer "photobook_template_id",              :null => false
    t.string  "titleimage"
  end

  create_table "photographer_details", :force => true do |t|
    t.string   "name",                                                      :null => false
    t.string   "address",                                                   :null => false
    t.string   "city",                                                      :null => false
    t.string   "phone",               :limit => 100,                        :null => false
    t.string   "email",               :limit => 100,                        :null => false
    t.string   "amount",              :limit => 100,                        :null => false
    t.string   "join",                                                      :null => false
    t.string   "location",            :limit => 100,                        :null => false
    t.string   "exp_level",                                                 :null => false
    t.string   "username",            :limit => 100,                        :null => false
    t.string   "password",            :limit => 100,                        :null => false
    t.integer  "status",                             :default => 0,         :null => false
    t.date     "created_at"
    t.date     "date_sent"
    t.datetime "account_expire_date"
    t.string   "account_status",      :limit => 0,   :default => "pending", :null => false
  end

  create_table "photographer_logs", :force => true do |t|
    t.string   "username",    :limit => 100
    t.string   "name",        :limit => 100
    t.datetime "login_time"
    t.datetime "logout_time"
  end

  create_table "photographer_personal_details", :force => true do |t|
    t.integer "uid",                                :null => false
    t.string  "fname",               :limit => 100, :null => false
    t.string  "mname",               :limit => 100, :null => false
    t.string  "lname",               :limit => 100, :null => false
    t.string  "address",                            :null => false
    t.string  "city",                :limit => 100, :null => false
    t.string  "state_name",          :limit => 100, :null => false
    t.string  "zipcode",             :limit => 100, :null => false
    t.string  "phone",               :limit => 100, :null => false
    t.string  "email",               :limit => 100, :null => false
    t.string  "dob",                 :limit => 100, :null => false
    t.string  "hobbies",             :limit => 100, :null => false
    t.string  "marital",             :limit => 100, :null => false
    t.string  "language",            :limit => 100, :null => false
    t.text    "describe",                           :null => false
    t.string  "institution",                        :null => false
    t.string  "certificate",                        :null => false
    t.string  "qualification",                      :null => false
    t.string  "license",                            :null => false
    t.string  "skills",                             :null => false
    t.text    "additional_info",                    :null => false
    t.string  "hobby",               :limit => 100, :null => false
    t.string  "part_time",           :limit => 100, :null => false
    t.string  "full_time",           :limit => 100, :null => false
    t.string  "monday",              :limit => 100, :null => false
    t.string  "tuesday",             :limit => 100, :null => false
    t.string  "wednesday",           :limit => 100, :null => false
    t.string  "thursday",            :limit => 100, :null => false
    t.string  "friday",              :limit => 100, :null => false
    t.string  "saturday",            :limit => 100, :null => false
    t.string  "sunday",              :limit => 100, :null => false
    t.string  "from_time",           :limit => 100, :null => false
    t.string  "to_time",             :limit => 100, :null => false
    t.string  "reference_name",      :limit => 100, :null => false
    t.string  "reference_title",     :limit => 100, :null => false
    t.string  "reference_address",                  :null => false
    t.string  "reference_phone",     :limit => 100, :null => false
    t.string  "competent",           :limit => 100, :null => false
    t.string  "under_age",           :limit => 100, :null => false
    t.string  "physical",            :limit => 100, :null => false
    t.string  "nationality_number",  :limit => 100, :null => false
    t.string  "passport_number",     :limit => 100, :null => false
    t.string  "license_number",      :limit => 100, :null => false
    t.string  "voters_number",       :limit => 100, :null => false
    t.string  "incometax_number",    :limit => 100, :null => false
    t.string  "security_number",     :limit => 100, :null => false
    t.string  "collegeid_number",    :limit => 100, :null => false
    t.string  "bankruptcy",          :limit => 100, :null => false
    t.string  "criminal",            :limit => 100, :null => false
    t.text    "describe_crimes",                    :null => false
    t.string  "imprisoned",          :limit => 100, :null => false
    t.text    "describe_imprisoned",                :null => false
    t.string  "alcohol",             :limit => 100, :null => false
    t.string  "rehabilitation",      :limit => 100, :null => false
    t.string  "invest",              :limit => 100, :null => false
    t.string  "earn",                :limit => 100, :null => false
    t.date    "created_at",                         :null => false
  end

  create_table "portfolio_samples", :force => true do |t|
    t.integer  "studio_portfolio_id"
    t.string   "sample_image",        :limit => 100
    t.datetime "created_at"
    t.datetime "modified_at"
  end

  create_table "print_size_prices", :force => true do |t|
    t.integer  "studio_id",                       :default => 0
    t.string   "studio_type",       :limit => 0,                     :null => false
    t.integer  "print_size_id",                                      :null => false
    t.float    "price",             :limit => 10,                    :null => false
    t.integer  "pricelt72"
    t.integer  "process_studio_id",               :default => 0,     :null => false
    t.boolean  "default_size",                    :default => false, :null => false
    t.integer  "quantity",                        :default => 1
    t.string   "aspect_ratio",      :limit => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "print_sizes", :force => true do |t|
    t.string   "label",                                     :null => false
    t.decimal  "width",      :precision => 10, :scale => 2, :null => false
    t.decimal  "height",     :precision => 10, :scale => 2, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_details", :force => true do |t|
    t.integer "cartid",        :default => 0, :null => false
    t.integer "no_of_moments", :default => 0, :null => false
    t.integer "no_of_copies",  :default => 0, :null => false
    t.integer "product_price", :default => 0, :null => false
    t.integer "product_id",    :default => 0, :null => false
  end

  create_table "products", :force => true do |t|
    t.string  "product_name",                                 :null => false
    t.integer "price",                                        :null => false
    t.string  "ptype",        :limit => 0, :default => "hmm", :null => false
    t.integer "store_id",                  :default => 0,     :null => false
  end

  create_table "promo_codes", :force => true do |t|
    t.string   "promocode",  :limit => 100
    t.integer  "used",                      :default => 0
    t.string   "code_type",  :limit => 100
    t.float    "amt",        :limit => 10,  :default => 0.0
    t.datetime "created_at"
  end

  create_table "sale_users", :force => true do |t|
    t.string "user_name",                                    :null => false
    t.string "password",                                     :null => false
    t.string "type",       :limit => 0, :default => "admin", :null => false
    t.date   "created_at",                                   :null => false
    t.date   "updated_at",                                   :null => false
  end

  create_table "sales_managers", :force => true do |t|
    t.string   "name"
    t.string   "username",    :null => false
    t.string   "password",    :null => false
    t.string   "email",       :null => false
    t.datetime "created_at",  :null => false
    t.datetime "modified_at", :null => false
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "share_comments", :force => true do |t|
    t.string   "name"
    t.text     "comment"
    t.integer  "uid",        :limit => 8
    t.datetime "d_add_date"
    t.integer  "share_id",   :limit => 8,                        :null => false
    t.string   "e_approved", :limit => 0, :default => "pending", :null => false
    t.text     "reply"
  end

  create_table "share_journalcomments", :force => true do |t|
    t.integer  "shareid",      :limit => 8,                        :null => false
    t.integer  "journal_id",   :limit => 8,                        :null => false
    t.string   "journal_type",                                     :null => false
    t.string   "name",                                             :null => false
    t.text     "comment",                                          :null => false
    t.datetime "comment_date",                                     :null => false
    t.text     "Reply"
    t.string   "ctype",                                            :null => false
    t.string   "status",       :limit => 0, :default => "pending", :null => false
  end

  create_table "share_journals", :force => true do |t|
    t.integer  "presenter_id", :limit => 8,                      :null => false
    t.integer  "jid",          :limit => 8,                      :null => false
    t.string   "jtype",                                          :null => false
    t.text     "e_mail",                                         :null => false
    t.datetime "created_date",                                   :null => false
    t.datetime "expiry_date",                                    :null => false
    t.text     "message",                                        :null => false
    t.string   "shown",        :limit => 0, :default => "false", :null => false
    t.string   "unid",                                           :null => false
  end

  create_table "share_memories", :force => true do |t|
    t.integer  "presenter_id", :limit => 8, :null => false
    t.text     "email_list",                :null => false
    t.string   "xml_name",                  :null => false
    t.datetime "created_date",              :null => false
    t.datetime "expiry_date",               :null => false
  end

  create_table "share_momentcomments", :force => true do |t|
    t.string   "name",                                           :null => false
    t.text     "comment",                                        :null => false
    t.datetime "added_date",                                     :null => false
    t.integer  "share_id",   :limit => 8,                        :null => false
    t.string   "e_approved", :limit => 0, :default => "pending", :null => false
    t.text     "reply"
    t.string   "ctype",                                          :null => false
    t.integer  "uid",        :limit => 8,                        :null => false
  end

  create_table "share_moments", :force => true do |t|
    t.integer  "presenter_id",   :limit => 8,                            :null => false
    t.integer  "usercontent_id", :limit => 8,                            :null => false
    t.string   "moment_type",                                            :null => false
    t.string   "email",                                                  :null => false
    t.datetime "created_date",                                           :null => false
    t.datetime "expiry_date",                                            :null => false
    t.text     "message",                                                :null => false
    t.string   "unid",                                                   :null => false
    t.string   "ctype",                       :default => "momentShare", :null => false
    t.string   "shown",          :limit => 0, :default => "false",       :null => false
    t.string   "status",         :limit => 0, :default => "pending",     :null => false
  end

  create_table "shared_moment_ids", :force => true do |t|
    t.integer "share_id",  :limit => 8, :null => false
    t.integer "moment_id", :limit => 8, :null => false
  end

  create_table "shares", :force => true do |t|
    t.integer  "presenter_id", :limit => 8,                                                             :null => false
    t.text     "email_list",                                                                            :null => false
    t.string   "xml_name",                                                                              :null => false
    t.datetime "created_date",                                                                          :null => false
    t.datetime "expiry_date",                                                                           :null => false
    t.string   "guest_name"
    t.datetime "Visited_date"
    t.text     "message"
    t.string   "password"
    t.string   "unid"
    t.string   "shown",        :limit => 0,   :default => "false",                                      :null => false
    t.string   "ctype",                       :default => "share",                                      :null => false
    t.string   "icon",         :limit => 500, :default => "/user_content/photos/flex_icon/noimage.jpg", :null => false
    t.string   "processed",    :limit => 0,   :default => "no"
    t.string   "img_url",                     :default => "http://content.holdmymemories.com"
  end

  create_table "shipping_informations", :force => true do |t|
    t.integer "user_id",                :null => false
    t.string  "name",                   :null => false
    t.string  "lname",                  :null => false
    t.string  "address",                :null => false
    t.string  "city",                   :null => false
    t.string  "zip",     :limit => 100, :null => false
    t.string  "state",                  :null => false
    t.string  "country",                :null => false
    t.string  "phno",                   :null => false
    t.string  "email",                  :null => false
    t.integer "visitor", :limit => 1
  end

  create_table "shipping_methods", :force => true do |t|
    t.string   "method_name"
    t.integer  "studio_id",   :default => 0, :null => false
    t.datetime "created_at"
  end

  create_table "shipping_prices", :force => true do |t|
    t.integer  "method_id"
    t.float    "start_price", :limit => 10
    t.float    "end_price",   :limit => 10
    t.float    "ship_price",  :limit => 10, :null => false
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "simple_captcha_data", :force => true do |t|
    t.string   "key",        :null => false
    t.string   "value",      :null => false
    t.datetime "updated_at", :null => false
    t.datetime "created_at", :null => false
  end

  create_table "sizes", :force => true do |t|
    t.integer  "studio_id",                  :default => 0
    t.string   "studio_type",  :limit => 0,                     :null => false
    t.string   "name",         :limit => 50
    t.float    "height",       :limit => 10
    t.float    "width",        :limit => 10
    t.float    "dpi",          :limit => 10
    t.float    "price",        :limit => 10,                    :null => false
    t.boolean  "default_size",               :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "slide_shows", :force => true do |t|
    t.string "img_name", :null => false
    t.text   "desc",     :null => false
  end

  create_table "slideshow_details", :force => true do |t|
    t.integer "slideshow_moment_id", :limit => 8,                                                    :null => false
    t.string  "swf",                 :limit => 250,                                                  :null => false
    t.string  "title",               :limit => 250,                                                  :null => false
    t.string  "song",                :limit => 250,                                                  :null => false
    t.string  "img_url",                            :default => "http://content.holdmymemories.com"
  end

  create_table "slideshow_moment_ids", :force => true do |t|
    t.integer "slideshow_id", :limit => 8, :null => false
    t.integer "moment_id",    :limit => 8, :null => false
  end

  create_table "social_networkings", :force => true do |t|
    t.integer  "uid",            :limit => 8,                :null => false
    t.string   "family_website",                             :null => false
    t.integer  "facebook_count", :limit => 8, :default => 0, :null => false
    t.integer  "myspace_count",  :limit => 8, :default => 0, :null => false
    t.integer  "twitter_count",  :limit => 8, :default => 0, :null => false
    t.integer  "other_count",    :limit => 8, :default => 0, :null => false
    t.datetime "linked_date"
  end

  create_table "social_networks", :force => true do |t|
    t.integer  "uid"
    t.string   "share_type",   :limit => 0
    t.integer  "share_counts"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "state_salestaxes", :force => true do |t|
    t.integer  "state_id",                                       :null => false
    t.string   "tax_applicable", :limit => 0, :default => "No",  :null => false
    t.float    "tax_rate",       :limit => 5, :default => 0.0,   :null => false
    t.string   "order_from",     :limit => 0, :default => "hmm", :null => false
    t.datetime "created_at"
    t.datetime "modified_at"
  end

  create_table "states", :force => true do |t|
    t.string "abbreviation", :null => false
    t.string "state",        :null => false
  end

  create_table "studio_benefits", :force => true do |t|
    t.integer  "studio_id"
    t.integer  "studio_group_id", :default => 0
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "studio_commissions", :force => true do |t|
    t.integer "uid",                 :limit => 8,                         :null => false
    t.integer "emp_id",              :limit => 8,                         :null => false
    t.integer "store_id",            :limit => 8,                         :null => false
    t.float   "amount",                                                   :null => false
    t.string  "months",              :limit => 10,                        :null => false
    t.date    "payment_recieved_on",                                      :null => false
    t.string  "subscriptionumber"
    t.string  "status",              :limit => 0,   :default => "active", :null => false
    t.string  "reason",              :limit => 250
  end

  create_table "studio_details", :force => true do |t|
    t.string   "studio_name",                                               :null => false
    t.string   "address",                                                   :null => false
    t.string   "city",                                                      :null => false
    t.string   "country",             :limit => 100
    t.string   "studio_phone",        :limit => 100,                        :null => false
    t.string   "website",             :limit => 100,                        :null => false
    t.string   "name",                                                      :null => false
    t.string   "email",               :limit => 100,                        :null => false
    t.string   "phone",               :limit => 100,                        :null => false
    t.string   "username",            :limit => 100,                        :null => false
    t.string   "password",            :limit => 100,                        :null => false
    t.string   "children",            :limit => 0,   :default => "no"
    t.string   "family",              :limit => 0,   :default => "no"
    t.string   "maternity",           :limit => 0,   :default => "no"
    t.string   "glamour",             :limit => 0,   :default => "no"
    t.string   "high_school",         :limit => 0,   :default => "no"
    t.string   "bridal",              :limit => 0,   :default => "no"
    t.string   "weddings",            :limit => 0,   :default => "no"
    t.string   "others",              :limit => 100
    t.string   "avg_sessions",        :limit => 100
    t.string   "notes",               :limit => 100
    t.string   "follow_datetime",     :limit => 100
    t.string   "follow_person",       :limit => 100
    t.integer  "status",                             :default => 0,         :null => false
    t.datetime "created_at"
    t.date     "date_sent"
    t.datetime "account_expire_date"
    t.string   "account_status",      :limit => 0,   :default => "pending", :null => false
  end

  create_table "studio_owner_licenses", :force => true do |t|
    t.integer  "owner_id"
    t.string   "license_info",          :limit => 100
    t.string   "license_date",          :limit => 100
    t.string   "license_licensor",      :limit => 100
    t.string   "license_studio",        :limit => 100
    t.string   "license_location",      :limit => 100
    t.string   "licensor_address",      :limit => 100
    t.string   "licensor_attn",         :limit => 100
    t.string   "licensor_attn1",        :limit => 100
    t.string   "licensor_attn2",        :limit => 100
    t.string   "licensor_fax",          :limit => 100
    t.string   "licensor_studio",       :limit => 100
    t.string   "licensor_studio_by",    :limit => 100
    t.string   "licensor_studio_title", :limit => 100
    t.string   "billing_fname",         :limit => 100
    t.string   "billing_lname",         :limit => 100
    t.string   "billing_address",       :limit => 100
    t.string   "billing_city",          :limit => 100
    t.string   "billing_state",         :limit => 100
    t.string   "billing_zip",           :limit => 100
    t.string   "billing_country",       :limit => 100
    t.string   "billing_phone",         :limit => 100
    t.string   "billing_email",         :limit => 100
    t.integer  "menu_show",                            :default => 0
    t.string   "promocode",             :limit => 100
    t.string   "code_type",             :limit => 100
    t.datetime "created_at"
  end

  create_table "studio_portfolios", :force => true do |t|
    t.integer  "studio_id"
    t.string   "category_name"
    t.string   "category_image", :limit => 100
    t.string   "img_url",                       :default => "http://stagingcontent1.holdmymemories.com", :null => false
    t.datetime "created_at"
    t.datetime "modified_at"
  end

  create_table "studio_specials", :force => true do |t|
    t.integer  "studio_id"
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "modified_at"
  end

  create_table "sub_chap_journals", :force => true do |t|
    t.integer  "tag_id",          :limit => 8
    t.integer  "sub_chap_id",     :limit => 8,                        :null => false
    t.string   "journal_title",                                       :null => false
    t.text     "subchap_journal",                                     :null => false
    t.datetime "created_on",                                          :null => false
    t.datetime "updated_on",                                          :null => false
    t.string   "jtype",                        :default => "subchap", :null => false
    t.string   "source",          :limit => 0, :default => "website", :null => false
  end

  create_table "sub_chapters", :force => true do |t|
    t.integer  "uid"
    t.integer  "tagid"
    t.string   "sub_chapname",          :limit => 100
    t.string   "status",                :limit => 0,   :default => "active",                                   :null => false
    t.string   "v_image",                                                                                      :null => false
    t.text     "permissions"
    t.string   "e_access",              :limit => 0,   :default => "private",                                  :null => false
    t.string   "v_subchapter_tags",     :limit => 512, :default => "Add Tags Here",                            :null => false
    t.string   "v_desc",                :limit => 512, :default => "Enter Description Here",                   :null => false
    t.datetime "d_created_on",                                                                                 :null => false
    t.datetime "d_updated_on",                                                                                 :null => false
    t.string   "img_url",                              :default => "http://stagingcontent.holdmymemories.com"
    t.datetime "deleted_date"
    t.integer  "order_num",                            :default => 0,                                          :null => false
    t.date     "start_date"
    t.date     "end_date"
    t.boolean  "mobile_facebook_share",                :default => false,                                      :null => false
    t.integer  "child_count"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "store_id",              :limit => 8
    t.boolean  "auto_share",                           :default => false,                                      :null => false
    t.string   "client",                :limit => 0,   :default => "website",                                  :null => false
    t.boolean  "facebook_share",                       :default => false,                                      :null => false
    t.string   "studio_status",         :limit => 0,   :default => "no",                                       :null => false
  end

  create_table "subchap_comments", :force => true do |t|
    t.integer  "uid",          :limit => 8
    t.integer  "subchap_id",   :limit => 8,                              :null => false
    t.integer  "subchap_jid",  :limit => 8
    t.string   "v_name"
    t.text     "v_comments",                                             :null => false
    t.datetime "d_created_on",                                           :null => false
    t.string   "e_approval",   :limit => 0,   :default => "pending",     :null => false
    t.string   "ctype",        :limit => 250, :default => "sub_chapter", :null => false
    t.string   "reply"
  end

  create_table "successful_transactions", :force => true do |t|
    t.string   "subscriptionID",                    :null => false
    t.string   "subscriptionStatus", :limit => 200, :null => false
    t.string   "payment",            :limit => 150, :null => false
    t.integer  "totalRecurrences",   :limit => 8,   :null => false
    t.string   "transactionID",      :limit => 200, :null => false
    t.string   "amount",             :limit => 100, :null => false
    t.string   "currency",           :limit => 100, :null => false
    t.string   "method",             :limit => 200, :null => false
    t.string   "custFirstName",                     :null => false
    t.string   "custLastName",                      :null => false
    t.string   "respCode",                          :null => false
    t.text     "respText",                          :null => false
    t.datetime "transdate",                         :null => false
  end

  create_table "tags", :force => true do |t|
    t.integer  "uid"
    t.integer  "sub_chapid"
    t.string   "v_tagname",      :limit => 50,                                                          :null => false
    t.string   "v_chapimage",    :limit => 100
    t.string   "default_tag",    :limit => 0,   :default => "yes"
    t.string   "e_access",       :limit => 0
    t.string   "e_visible",      :limit => 0
    t.datetime "d_createddate",                                                                         :null => false
    t.datetime "d_updateddate",                                                                         :null => false
    t.string   "status",         :limit => 0,   :default => "active",                                   :null => false
    t.text     "permissions"
    t.string   "v_chapter_tags", :limit => 512, :default => "Add Tags Here",                            :null => false
    t.string   "v_desc",         :limit => 512, :default => "Enter Description Here",                   :null => false
    t.string   "img_url",                       :default => "http://stagingcontent.holdmymemories.com"
    t.datetime "deleted_date"
    t.integer  "order_num",                     :default => 0,                                          :null => false
    t.string   "tag_type",       :limit => 0,   :default => "chapter",                                  :null => false
    t.string   "import_type",    :limit => 0,   :default => "default",                                  :null => false
    t.boolean  "auto_share",                    :default => false,                                      :null => false
    t.integer  "child_count"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "client",         :limit => 0,   :default => "website",                                  :null => false
    t.boolean  "facebook_share",                :default => false,                                      :null => false
  end

  create_table "temp_uploads", :force => true do |t|
    t.integer "uid",        :limit => 8, :null => false
    t.integer "content_id", :limit => 8, :null => false
  end

  create_table "temps", :force => true do |t|
    t.string   "v_fname",                                                                                         :null => false
    t.string   "v_lname",                                                                                         :null => false
    t.string   "e_sex",                     :limit => 10,                                                         :null => false
    t.string   "marital_status",            :limit => 0,   :default => "married"
    t.string   "v_user_name",                                                                                     :null => false
    t.string   "v_password",                                                                                      :null => false
    t.string   "v_add1"
    t.string   "v_add2"
    t.string   "v_city",                    :limit => 100
    t.string   "v_state",                   :limit => 100
    t.string   "v_country",                 :limit => 100,                                                        :null => false
    t.string   "v_zip",                     :limit => 100,                                                        :null => false
    t.string   "v_e_mail",                  :limit => 100,                                                        :null => false
    t.string   "e_user_status",             :limit => 0,   :default => "unblocked",                               :null => false
    t.integer  "i_ip_add"
    t.integer  "i_login_status"
    t.datetime "d_created_date",                                                                                  :null => false
    t.datetime "d_updated_date",                                                                                  :null => false
    t.date     "d_bdate",                                                                                         :null => false
    t.string   "v_myimage",                 :limit => 100, :default => "blank.jpg"
    t.string   "v_security_q",              :limit => 256,                                                        :null => false
    t.string   "v_security_a",              :limit => 256,                                                        :null => false
    t.text     "v_abt_me"
    t.string   "v_link1"
    t.string   "v_link2"
    t.string   "v_link3"
    t.string   "knowhmm"
    t.string   "refral"
    t.string   "family_name"
    t.string   "family_header",                            :default => "Welcome to:",                             :null => false
    t.string   "familyname_select"
    t.string   "family_footer",                            :default => "Family Website",                          :null => false
    t.string   "family_pic",                               :default => "defaultfamily.jpg"
    t.text     "about_family"
    t.text     "family_history"
    t.string   "familypage_image"
    t.string   "familyheader_image"
    t.string   "familyfooter_image"
    t.string   "familywebsite_password"
    t.string   "password_required",         :limit => 0,   :default => "no",                                      :null => false
    t.string   "upload_type",               :limit => 0,   :default => "basic",                                   :null => false
    t.string   "img_url",                                  :default => "http://contentbackup.holdmymemories.com"
    t.text     "street_address"
    t.string   "suburb"
    t.string   "postcode",                  :limit => 50
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "telephone"
    t.string   "fax"
    t.string   "account_type",              :limit => 0,   :default => "free_user",                               :null => false
    t.integer  "emp_id",                    :limit => 8
    t.string   "unid"
    t.date     "account_expdate"
    t.string   "subscriptionnumber"
    t.string   "invoicenumber"
    t.string   "months"
    t.string   "amount"
    t.string   "substatus",                 :limit => 0,   :default => "active"
    t.datetime "suspended_date"
    t.string   "cupon_no"
    t.text     "cancel_reason"
    t.string   "cancel_status",             :limit => 0
    t.datetime "cancellation_request_date"
    t.integer  "canceled_by",               :limit => 8
    t.integer  "payments_recieved",         :limit => 8,   :default => 1
    t.string   "alt_family_name"
    t.datetime "billed_date"
    t.string   "billed_status",             :limit => 0
    t.string   "msg",                       :limit => 0,   :default => "0",                                       :null => false
    t.integer  "themes_id",                                :default => 1,                                         :null => false
    t.string   "themes",                                   :default => "myfamilywebsite",                         :null => false
    t.string   "membership_sold_by"
    t.string   "terms_checked",             :limit => 0,   :default => "false"
    t.integer  "theme_id",                                 :default => 1,                                         :null => false
    t.string   "gift_coupon_id",            :limit => 100
    t.string   "process",                   :limit => 250
    t.integer  "studio_id",                 :limit => 8,   :default => 0,                                         :null => false
    t.text     "notes_link_to_customer"
    t.text     "reactivated_admin"
    t.integer  "facebook_profile_id",       :limit => 8,   :default => 0,                                         :null => false
    t.text     "studio_management_notes"
    t.text     "studio_manager_notes"
    t.integer  "old_emp_id"
    t.integer  "old_studio_id"
    t.string   "client",                    :limit => 0,   :default => "website",                                 :null => false
    t.date     "first_payment_date"
  end

  create_table "text_journals", :force => true do |t|
    t.integer  "category_id",   :limit => 8, :default => 0
    t.string   "journal_title"
    t.text     "description",                                    :null => false
    t.datetime "d_created_at",                                   :null => false
    t.datetime "d_updated_at",                                   :null => false
    t.string   "jtype",                      :default => "text"
    t.integer  "uid",           :limit => 8,                     :null => false
  end

  create_table "theme_categories", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "themes", :force => true do |t|
    t.integer  "category_id",                                                    :null => false
    t.string   "name",                                                           :null => false
    t.string   "stylesheet",                                                     :null => false
    t.string   "image",                                                          :null => false
    t.string   "header_color",      :limit => 10,  :default => "#000000",        :null => false
    t.string   "hmm_logo",          :limit => 100, :default => "logo_trans.png"
    t.string   "header_logo_color", :limit => 0,   :default => "black",          :null => false
    t.string   "status",            :limit => 0,   :default => "active",         :null => false
    t.datetime "created_at"
    t.datetime "modified_at"
  end

  create_table "tip_ideas", :force => true do |t|
    t.integer "uid",       :limit => 8, :null => false
    t.string  "tip_title",              :null => false
    t.text    "tip_desc",               :null => false
  end

  create_table "tips", :force => true do |t|
    t.string "title",       :null => false
    t.text   "description", :null => false
  end

  create_table "track_accounts", :force => true do |t|
    t.integer "not_canceled", :null => false
    t.integer "canceled",     :null => false
  end

  create_table "upload_import_counts", :force => true do |t|
    t.integer "hmm_user_id",  :limit => 8, :null => false
    t.string  "clicked_on",   :limit => 0, :null => false
    t.date    "clicked_date",              :null => false
  end

  create_table "user_contents", :force => true do |t|
    t.integer  "gallery_id",       :limit => 8,                                                           :null => false
    t.string   "v_tagname"
    t.integer  "tagid",                                                                                   :null => false
    t.integer  "sub_chapid"
    t.integer  "uid"
    t.string   "e_filetype",       :limit => 0,                                                           :null => false
    t.string   "e_access",         :limit => 0
    t.string   "e_visible",        :limit => 0,   :default => "no",                                       :null => false
    t.string   "v_filename",       :limit => 100,                                                         :null => false
    t.string   "v_desc"
    t.string   "v_tagphoto",       :limit => 100
    t.datetime "d_createddate",                                                                           :null => false
    t.datetime "d_momentdate",                                                                            :null => false
    t.string   "status",           :limit => 0,   :default => "active",                                   :null => false
    t.text     "permissions"
    t.integer  "views",            :limit => 8,   :default => 0,                                          :null => false
    t.integer  "flag",             :limit => 8
    t.string   "img_url",                         :default => "http://stagingcontent.holdmymemories.com"
    t.datetime "deleted_date"
    t.integer  "order_num",                       :default => 0,                                          :null => false
    t.string   "audio_tag"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "filename_extn"
    t.string   "latitude",         :limit => 25
    t.string   "longitude",        :limit => 25
    t.string   "client",           :limit => 0,   :default => "website",                                  :null => false
    t.string   "thumbnail_covert", :limit => 0,   :default => "no",                                       :null => false
  end

  create_table "user_sessions", :force => true do |t|
    t.string   "i_ip_add"
    t.integer  "uid"
    t.string   "v_user_name",                                 :null => false
    t.datetime "d_date_time",                                 :null => false
    t.string   "e_logged_in",  :limit => 0, :default => "no", :null => false
    t.string   "e_logged_out", :limit => 0, :default => "no", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "username",        :limit => 64
    t.string   "email",           :limit => 128
    t.string   "hashed_password", :limit => 64
    t.string   "enabled",         :limit => 0,   :default => "yes"
    t.text     "profile"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "last_login_at"
    t.integer  "acess_level",     :limit => 8
  end

  create_table "version_details", :force => true do |t|
    t.string   "file_name",   :limit => 100,                  :null => false
    t.string   "file_url",                                    :null => false
    t.string   "major",       :limit => 11,  :default => "1", :null => false
    t.string   "minor",       :limit => 11,  :default => "0", :null => false
    t.datetime "modified_at",                                 :null => false
  end

  create_table "wp_holdmymemoriescomments", :primary_key => "comment_ID", :force => true do |t|
    t.integer  "comment_post_ID",                     :default => 0,   :null => false
    t.text     "comment_author",       :limit => 255,                  :null => false
    t.string   "comment_author_email", :limit => 100, :default => "",  :null => false
    t.string   "comment_author_url",   :limit => 200, :default => "",  :null => false
    t.string   "comment_author_IP",    :limit => 100, :default => "",  :null => false
    t.datetime "comment_date",                                         :null => false
    t.datetime "comment_date_gmt",                                     :null => false
    t.text     "comment_content",                                      :null => false
    t.integer  "comment_karma",                       :default => 0,   :null => false
    t.string   "comment_approved",     :limit => 20,  :default => "1", :null => false
    t.string   "comment_agent",                       :default => "",  :null => false
    t.string   "comment_type",         :limit => 20,  :default => "",  :null => false
    t.integer  "comment_parent",       :limit => 8,   :default => 0,   :null => false
    t.integer  "user_id",              :limit => 8,   :default => 0,   :null => false
  end

  add_index "wp_holdmymemoriescomments", ["comment_approved", "comment_date_gmt"], :name => "comment_approved_date_gmt"
  add_index "wp_holdmymemoriescomments", ["comment_approved"], :name => "comment_approved"
  add_index "wp_holdmymemoriescomments", ["comment_date_gmt"], :name => "comment_date_gmt"
  add_index "wp_holdmymemoriescomments", ["comment_post_ID"], :name => "comment_post_ID"

  create_table "wp_holdmymemorieslinks", :primary_key => "link_id", :force => true do |t|
    t.string   "link_url",                             :default => "",  :null => false
    t.string   "link_name",                            :default => "",  :null => false
    t.string   "link_image",                           :default => "",  :null => false
    t.string   "link_target",      :limit => 25,       :default => "",  :null => false
    t.integer  "link_category",    :limit => 8,        :default => 0,   :null => false
    t.string   "link_description",                     :default => "",  :null => false
    t.string   "link_visible",     :limit => 20,       :default => "Y", :null => false
    t.integer  "link_owner",                           :default => 1,   :null => false
    t.integer  "link_rating",                          :default => 0,   :null => false
    t.datetime "link_updated",                                          :null => false
    t.string   "link_rel",                             :default => "",  :null => false
    t.text     "link_notes",       :limit => 16777215,                  :null => false
    t.string   "link_rss",                             :default => "",  :null => false
  end

  add_index "wp_holdmymemorieslinks", ["link_category"], :name => "link_category"
  add_index "wp_holdmymemorieslinks", ["link_visible"], :name => "link_visible"

  create_table "wp_holdmymemoriesoptions", :id => false, :force => true do |t|
    t.integer "option_id",    :limit => 8,                             :null => false
    t.integer "blog_id",                            :default => 0,     :null => false
    t.string  "option_name",  :limit => 64,         :default => "",    :null => false
    t.text    "option_value", :limit => 2147483647,                    :null => false
    t.string  "autoload",     :limit => 20,         :default => "yes", :null => false
  end

  add_index "wp_holdmymemoriesoptions", ["option_name"], :name => "option_name"

  create_table "wp_holdmymemoriespostmeta", :primary_key => "meta_id", :force => true do |t|
    t.integer "post_id",    :limit => 8,          :default => 0, :null => false
    t.string  "meta_key"
    t.text    "meta_value", :limit => 2147483647
  end

  add_index "wp_holdmymemoriespostmeta", ["meta_key"], :name => "meta_key"
  add_index "wp_holdmymemoriespostmeta", ["post_id"], :name => "post_id"

  create_table "wp_holdmymemoriesposts", :primary_key => "ID", :force => true do |t|
    t.integer  "post_author",           :limit => 8,          :default => 0,         :null => false
    t.datetime "post_date",                                                          :null => false
    t.datetime "post_date_gmt",                                                      :null => false
    t.text     "post_content",          :limit => 2147483647,                        :null => false
    t.text     "post_title",                                                         :null => false
    t.integer  "post_category",                               :default => 0,         :null => false
    t.text     "post_excerpt",                                                       :null => false
    t.string   "post_status",           :limit => 20,         :default => "publish", :null => false
    t.string   "comment_status",        :limit => 20,         :default => "open",    :null => false
    t.string   "ping_status",           :limit => 20,         :default => "open",    :null => false
    t.string   "post_password",         :limit => 20,         :default => "",        :null => false
    t.string   "post_name",             :limit => 200,        :default => "",        :null => false
    t.text     "to_ping",                                                            :null => false
    t.text     "pinged",                                                             :null => false
    t.datetime "post_modified",                                                      :null => false
    t.datetime "post_modified_gmt",                                                  :null => false
    t.text     "post_content_filtered",                                              :null => false
    t.integer  "post_parent",           :limit => 8,          :default => 0,         :null => false
    t.string   "guid",                                        :default => "",        :null => false
    t.integer  "menu_order",                                  :default => 0,         :null => false
    t.string   "post_type",             :limit => 20,         :default => "post",    :null => false
    t.string   "post_mime_type",        :limit => 100,        :default => "",        :null => false
    t.integer  "comment_count",         :limit => 8,          :default => 0,         :null => false
  end

  add_index "wp_holdmymemoriesposts", ["post_name"], :name => "post_name"
  add_index "wp_holdmymemoriesposts", ["post_parent"], :name => "post_parent"
  add_index "wp_holdmymemoriesposts", ["post_type", "post_status", "post_date", "ID"], :name => "type_status_date"

  create_table "wp_holdmymemoriesterm_relationships", :id => false, :force => true do |t|
    t.integer "object_id",        :limit => 8, :default => 0, :null => false
    t.integer "term_taxonomy_id", :limit => 8, :default => 0, :null => false
    t.integer "term_order",                    :default => 0, :null => false
  end

  add_index "wp_holdmymemoriesterm_relationships", ["term_taxonomy_id"], :name => "term_taxonomy_id"

  create_table "wp_holdmymemoriesterm_taxonomy", :primary_key => "term_taxonomy_id", :force => true do |t|
    t.integer "term_id",     :limit => 8,          :default => 0,  :null => false
    t.string  "taxonomy",    :limit => 32,         :default => "", :null => false
    t.text    "description", :limit => 2147483647,                 :null => false
    t.integer "parent",      :limit => 8,          :default => 0,  :null => false
    t.integer "count",       :limit => 8,          :default => 0,  :null => false
  end

  add_index "wp_holdmymemoriesterm_taxonomy", ["term_id", "taxonomy"], :name => "term_id_taxonomy", :unique => true

  create_table "wp_holdmymemoriesterms", :primary_key => "term_id", :force => true do |t|
    t.string  "name",       :limit => 200, :default => "", :null => false
    t.string  "slug",       :limit => 200, :default => "", :null => false
    t.integer "term_group", :limit => 8,   :default => 0,  :null => false
  end

  add_index "wp_holdmymemoriesterms", ["name"], :name => "name"
  add_index "wp_holdmymemoriesterms", ["slug"], :name => "slug", :unique => true

  create_table "wp_holdmymemoriesusermeta", :primary_key => "umeta_id", :force => true do |t|
    t.integer "user_id",    :limit => 8,          :default => 0, :null => false
    t.string  "meta_key"
    t.text    "meta_value", :limit => 2147483647
  end

  add_index "wp_holdmymemoriesusermeta", ["meta_key"], :name => "meta_key"
  add_index "wp_holdmymemoriesusermeta", ["user_id"], :name => "user_id"

  create_table "wp_holdmymemoriesusers", :primary_key => "ID", :force => true do |t|
    t.string   "user_login",          :limit => 60,  :default => "", :null => false
    t.string   "user_pass",           :limit => 64,  :default => "", :null => false
    t.string   "user_nicename",       :limit => 50,  :default => "", :null => false
    t.string   "user_email",          :limit => 100, :default => "", :null => false
    t.string   "user_url",            :limit => 100, :default => "", :null => false
    t.datetime "user_registered",                                    :null => false
    t.string   "user_activation_key", :limit => 60,  :default => "", :null => false
    t.integer  "user_status",                        :default => 0,  :null => false
    t.string   "display_name",        :limit => 250, :default => "", :null => false
  end

  add_index "wp_holdmymemoriesusers", ["user_login"], :name => "user_login_key"
  add_index "wp_holdmymemoriesusers", ["user_nicename"], :name => "user_nicename"

  create_table "zip_codes", :force => true do |t|
    t.string "zip_code",     :limit => 5,  :null => false
    t.string "city",         :limit => 50
    t.string "county",       :limit => 50
    t.string "state_name",   :limit => 50
    t.string "state_prefix", :limit => 2
    t.string "area_code",    :limit => 3
    t.string "time_zone",    :limit => 50
    t.float  "latitude",                   :null => false
    t.float  "longitude",                  :null => false
  end

  add_index "zip_codes", ["zip_code"], :name => "zip_code"

  create_table "zipcode_searches", :force => true do |t|
    t.string   "zip_code",   :limit => 100
    t.string   "miles",      :limit => 100
    t.string   "ip_address", :limit => 100
    t.datetime "created_at",                :null => false
  end

end
