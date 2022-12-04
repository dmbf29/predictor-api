# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_12_04_153322) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_stat_statements"
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "affiliations", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.bigint "group_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["group_id"], name: "index_affiliations_on_group_id"
    t.index ["team_id"], name: "index_affiliations_on_team_id"
  end

  create_table "competitions", force: :cascade do |t|
    t.string "name"
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "current_round_id"
    t.integer "api_id"
    t.index ["current_round_id"], name: "index_competitions_on_current_round_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.bigint "round_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "api_id"
    t.index ["round_id"], name: "index_groups_on_round_id"
  end

  create_table "leaderboards", force: :cascade do |t|
    t.string "name"
    t.string "password"
    t.bigint "user_id", null: false
    t.bigint "competition_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["competition_id"], name: "index_leaderboards_on_competition_id"
    t.index ["user_id"], name: "index_leaderboards_on_user_id"
  end

  create_table "matches", force: :cascade do |t|
    t.datetime "kickoff_time"
    t.integer "team_home_score"
    t.integer "team_away_score"
    t.string "status"
    t.bigint "group_id"
    t.bigint "team_away_id"
    t.bigint "team_home_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "next_match_id"
    t.bigint "round_id"
    t.integer "api_id"
    t.string "location"
    t.integer "team_home_et_score"
    t.integer "team_away_et_score"
    t.integer "team_home_ps_score"
    t.integer "team_away_ps_score"
    t.index ["group_id"], name: "index_matches_on_group_id"
    t.index ["next_match_id"], name: "index_matches_on_next_match_id"
    t.index ["round_id"], name: "index_matches_on_round_id"
    t.index ["team_away_id"], name: "index_matches_on_team_away_id"
    t.index ["team_home_id"], name: "index_matches_on_team_home_id"
  end

  create_table "memberships", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "leaderboard_id"
    t.index ["leaderboard_id"], name: "index_memberships_on_leaderboard_id"
    t.index ["user_id"], name: "index_memberships_on_user_id"
  end

  create_table "predictions", force: :cascade do |t|
    t.bigint "match_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "choice"
    t.index ["match_id"], name: "index_predictions_on_match_id"
    t.index ["user_id"], name: "index_predictions_on_user_id"
  end

  create_table "rounds", force: :cascade do |t|
    t.integer "number"
    t.string "name"
    t.bigint "competition_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "api_name"
    t.integer "points", null: false
    t.index ["competition_id"], name: "index_rounds_on_competition_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.string "abbrev"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "api_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "allow_password_change", default: false
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "email"
    t.string "name"
    t.boolean "admin", default: false
    t.string "timezone"
    t.json "tokens"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "photo_key"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "affiliations", "groups"
  add_foreign_key "affiliations", "teams"
  add_foreign_key "competitions", "rounds", column: "current_round_id"
  add_foreign_key "groups", "rounds"
  add_foreign_key "leaderboards", "competitions"
  add_foreign_key "leaderboards", "users"
  add_foreign_key "matches", "groups"
  add_foreign_key "matches", "matches", column: "next_match_id"
  add_foreign_key "matches", "rounds"
  add_foreign_key "matches", "teams", column: "team_away_id"
  add_foreign_key "matches", "teams", column: "team_home_id"
  add_foreign_key "memberships", "leaderboards"
  add_foreign_key "memberships", "users"
  add_foreign_key "predictions", "matches"
  add_foreign_key "predictions", "users"
  add_foreign_key "rounds", "competitions"

  create_view "match_results", sql_definition: <<-SQL
      WITH match_rounds AS (
           SELECT m_1.id AS match_id,
                  CASE
                      WHEN (m_1.round_id IS NOT NULL) THEN m_1.round_id
                      ELSE g.round_id
                  END AS round_id
             FROM ((matches m_1
               LEFT JOIN groups g ON ((m_1.group_id = g.id)))
               LEFT JOIN rounds r_1 ON ((m_1.round_id = r_1.id)))
          )
   SELECT m.id AS match_id,
      m.group_id,
      r.id AS round_id,
      r.competition_id,
      m.kickoff_time,
      m.team_home_score,
      m.team_away_score,
      m.status,
      m.team_away_id,
      m.team_home_id,
      m.created_at,
      m.updated_at,
      m.next_match_id,
      m.api_id,
      m.location,
      m.team_home_et_score,
      m.team_away_et_score,
      m.team_home_ps_score,
      m.team_away_ps_score,
          CASE
              WHEN (((m.status)::text = 'upcoming'::text) OR ((m.status)::text = 'started'::text)) THEN NULL::text
              WHEN ((m.team_home_score = m.team_away_score) AND (m.team_home_et_score = m.team_away_et_score) AND (m.team_home_ps_score = m.team_away_ps_score)) THEN 'draw'::text
              WHEN ((m.team_home_score > m.team_away_score) OR ((m.team_home_et_score IS NOT NULL) AND (m.team_home_et_score > m.team_away_et_score)) OR ((m.team_home_ps_score IS NOT NULL) AND (m.team_home_ps_score > m.team_away_ps_score))) THEN 'home'::text
              ELSE 'away'::text
          END AS winning_side,
          CASE
              WHEN (((m.status)::text = 'upcoming'::text) OR ((m.status)::text = 'started'::text)) THEN NULL::bigint
              WHEN ((m.team_home_score = m.team_away_score) AND (m.team_home_et_score = m.team_away_et_score) AND (m.team_home_ps_score = m.team_away_ps_score)) THEN NULL::bigint
              WHEN ((m.team_home_score > m.team_away_score) OR ((m.team_home_et_score IS NOT NULL) AND (m.team_home_et_score > m.team_away_et_score)) OR ((m.team_home_ps_score IS NOT NULL) AND (m.team_home_ps_score > m.team_away_ps_score))) THEN m.team_home_id
              ELSE m.team_away_id
          END AS winner_id,
      r.number AS round_number,
      r.points,
      r.name AS round_name
     FROM ((matches m
       JOIN match_rounds mr ON ((mr.match_id = m.id)))
       JOIN rounds r ON ((mr.round_id = r.id)));
  SQL
  create_view "user_scores", sql_definition: <<-SQL
      WITH prediction_scores AS (
           SELECT p_1.id AS prediction_id,
                  CASE
                      WHEN (((mr_1.status)::text = 'finished'::text) AND (p_1.choice IS NOT NULL)) THEN true
                      ELSE false
                  END AS completed,
                  CASE
                      WHEN (((mr_1.status)::text = 'finished'::text) AND ((p_1.choice)::text = mr_1.winning_side)) THEN true
                      ELSE false
                  END AS correct,
                  CASE
                      WHEN (((mr_1.status)::text = 'finished'::text) AND ((p_1.choice)::text = mr_1.winning_side)) THEN mr_1.points
                      ELSE 0
                  END AS prediction_score
             FROM (predictions p_1
               LEFT JOIN match_results mr_1 ON ((mr_1.match_id = p_1.match_id)))
          )
   SELECT u.id AS user_id,
      mr.competition_id,
      sum(ps.prediction_score) AS score,
      count(ps.prediction_id) AS total_predictions,
      count(
          CASE
              WHEN ps.completed THEN 1
              ELSE NULL::integer
          END) AS completed_predictions,
      count(
          CASE
              WHEN ps.correct THEN 1
              ELSE NULL::integer
          END) AS correct_predictions,
          CASE
              WHEN (count(
              CASE
                  WHEN ps.completed THEN 1
                  ELSE NULL::integer
              END) > 0) THEN (((count(
              CASE
                  WHEN ps.correct THEN 1
                  ELSE NULL::integer
              END))::numeric * 1.0) / (count(
              CASE
                  WHEN ps.completed THEN 1
                  ELSE NULL::integer
              END))::numeric)
              ELSE NULL::numeric
          END AS accuracy
     FROM (((users u
       LEFT JOIN predictions p ON ((p.user_id = u.id)))
       LEFT JOIN prediction_scores ps ON ((ps.prediction_id = p.id)))
       LEFT JOIN match_results mr ON ((mr.match_id = p.match_id)))
    GROUP BY u.id, mr.competition_id
    ORDER BY u.id;
  SQL
  create_view "leaderboard_rankings", sql_definition: <<-SQL
      SELECT l.id AS leaderboard_id,
      l.competition_id,
      us.user_id,
      us.score,
      us.accuracy,
      us.completed_predictions,
      rank() OVER (PARTITION BY l.id ORDER BY us.score DESC, us.accuracy DESC, us.completed_predictions DESC) AS user_rank
     FROM (leaderboards l
       JOIN user_scores us ON ((us.competition_id = l.competition_id)))
    GROUP BY l.id, us.user_id, us.score, us.accuracy, us.completed_predictions;
  SQL
end
