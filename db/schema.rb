# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120502194734) do

  create_table "admins", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "admins", ["email"], :name => "index_admins_on_email", :unique => true
  add_index "admins", ["reset_password_token"], :name => "index_admins_on_reset_password_token", :unique => true

  create_table "affiliations", :force => true do |t|
    t.string   "name"
    t.integer  "location_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "social_info_id"
  end

  add_index "affiliations", ["location_id"], :name => "index_affiliations_on_location_id"
  add_index "affiliations", ["social_info_id"], :name => "index_affiliations_on_social_info_id"

  create_table "conferences", :force => true do |t|
    t.string   "name"
    t.integer  "league_id",  :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "conferences", ["league_id"], :name => "index_conferences_on_league_id"

  create_table "countries", :force => true do |t|
    t.string   "name"
    t.string   "abbreviation", :limit => 3
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "divisions", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.integer  "league_id",  :default => 1, :null => false
  end

  add_index "divisions", ["league_id"], :name => "index_divisions_on_league_id"

  create_table "events", :force => true do |t|
    t.string   "name"
    t.integer  "home_team_id",     :null => false
    t.integer  "visiting_team_id", :null => false
    t.date     "event_date",       :null => false
    t.time     "event_time"
    t.integer  "location_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "events", ["home_team_id"], :name => "index_events_on_home_team_id"
  add_index "events", ["location_id"], :name => "index_events_on_location_id"
  add_index "events", ["visiting_team_id"], :name => "index_events_on_visiting_team_id"

  create_table "game_watches", :force => true do |t|
    t.string   "name"
    t.integer  "event_id"
    t.integer  "venue_id"
    t.integer  "creator_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "game_watches", ["creator_id"], :name => "index_game_watches_on_creator_id"
  add_index "game_watches", ["event_id"], :name => "index_game_watches_on_event_id"
  add_index "game_watches", ["venue_id"], :name => "index_game_watches_on_venue_id"

  create_table "leagues", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "sport_id",   :null => false
  end

  add_index "leagues", ["sport_id"], :name => "index_leagues_on_sport_id"

  create_table "locations", :force => true do |t|
    t.string   "name"
    t.string   "address1",                   :null => false
    t.string   "address2"
    t.string   "city"
    t.integer  "state_id",                   :null => false
    t.string   "postal_code"
    t.integer  "country_id",  :default => 1, :null => false
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "locations", ["country_id"], :name => "index_locations_on_country_id"
  add_index "locations", ["state_id"], :name => "index_locations_on_state_id"

  create_table "people", :force => true do |t|
    t.string   "first_name",     :null => false
    t.string   "last_name",      :null => false
    t.string   "home_town"
    t.string   "home_school"
    t.string   "position"
    t.string   "type"
    t.integer  "social_info_id"
    t.integer  "team_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "people", ["social_info_id"], :name => "index_people_on_social_info_id"
  add_index "people", ["team_id"], :name => "index_people_on_team_id"

  create_table "social_infos", :force => true do |t|
    t.string   "twitter_name"
    t.string   "facebook_page_url"
    t.string   "web_url"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "hash_tags"
  end

  create_table "sports", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sports", ["name"], :name => "index_sports_on_name", :unique => true

  create_table "states", :force => true do |t|
    t.string   "name"
    t.string   "abbreviation", :limit => 3
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "teams", :force => true do |t|
    t.string   "name",           :null => false
    t.integer  "sport_id",       :null => false
    t.integer  "league_id",      :null => false
    t.integer  "division_id"
    t.integer  "conference_id"
    t.integer  "location_id",    :null => false
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "affiliation_id"
    t.integer  "social_info_id"
    t.integer  "espn_team_id"
    t.string   "espn_team_url"
  end

  add_index "teams", ["affiliation_id"], :name => "index_teams_on_affiliation_id"
  add_index "teams", ["conference_id"], :name => "index_teams_on_conference_id"
  add_index "teams", ["division_id"], :name => "index_teams_on_division_id"
  add_index "teams", ["espn_team_id"], :name => "index_teams_on_espn_team_id", :unique => true
  add_index "teams", ["league_id"], :name => "index_teams_on_league_id"
  add_index "teams", ["location_id"], :name => "index_teams_on_location_id"
  add_index "teams", ["social_info_id"], :name => "index_teams_on_social_info_id"
  add_index "teams", ["sport_id"], :name => "index_teams_on_sport_id"

  create_table "user_teams", :force => true do |t|
    t.integer  "user_id"
    t.integer  "team_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "user_teams", ["team_id"], :name => "index_user_teams_on_team_id"
  add_index "user_teams", ["user_id"], :name => "index_user_teams_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "twitter_username"
    t.string   "twitter_user_token"
    t.string   "twitter_user_secret"
    t.string   "facebook_user_id"
    t.string   "facebook_access_token"
    t.string   "twitter_user_id"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["facebook_user_id"], :name => "index_users_on_facebook_user_id", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["twitter_user_token"], :name => "index_users_on_twitter_user_token", :unique => true

  create_table "venue_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "venues", :force => true do |t|
    t.string   "name",           :null => false
    t.integer  "social_info_id"
    t.integer  "location_id"
    t.integer  "venue_type_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "venues", ["location_id"], :name => "index_venues_on_location_id"
  add_index "venues", ["social_info_id"], :name => "index_venues_on_social_info_id"
  add_index "venues", ["venue_type_id"], :name => "index_venues_on_venue_type_id"

  create_table "watch_sites", :force => true do |t|
    t.string   "name"
    t.integer  "team_id",    :null => false
    t.integer  "venue_id",   :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "watch_sites", ["team_id"], :name => "index_watch_sites_on_team_id"
  add_index "watch_sites", ["venue_id"], :name => "index_watch_sites_on_venue_id"

end
