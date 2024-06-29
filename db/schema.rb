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

ActiveRecord::Schema.define(version: 2024_06_27_134655) do

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
    t.string "api_code"
    t.index ["current_round_id"], name: "index_competitions_on_current_round_id"
  end

  create_table "emails", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "notification"
    t.string "topic_type"
    t.bigint "topic_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["topic_type", "topic_id"], name: "index_emails_on_topic"
    t.index ["user_id"], name: "index_emails_on_user_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.bigint "round_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "api_id"
    t.string "api_code"
    t.index ["round_id"], name: "index_groups_on_round_id"
  end

  create_table "leaderboards", force: :cascade do |t|
    t.string "name"
    t.string "password"
    t.bigint "user_id", null: false
    t.bigint "competition_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "description"
    t.boolean "auto_join", default: false, null: false
    t.boolean "leave_disabled", default: false, null: false
    t.integer "rankings_top_n"
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
    t.bigint "round_id", null: false
    t.integer "api_id"
    t.string "location"
    t.integer "team_home_et_score"
    t.integer "team_away_et_score"
    t.integer "team_home_ps_score"
    t.integer "team_away_ps_score"
    t.bigint "competition_id", null: false
    t.index ["competition_id"], name: "index_matches_on_competition_id"
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
    t.jsonb "notifications", default: {}
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["notifications"], name: "index_users_on_notifications", using: :gin
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "affiliations", "groups"
  add_foreign_key "affiliations", "teams"
  add_foreign_key "competitions", "rounds", column: "current_round_id"
  add_foreign_key "emails", "users"
  add_foreign_key "groups", "rounds"
  add_foreign_key "leaderboards", "competitions"
  add_foreign_key "leaderboards", "users"
  add_foreign_key "matches", "competitions"
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

  create_view "match_results", materialized: true, sql_definition: <<-SQL
      WITH leaderboard_users AS (
           SELECT leaderboards.id,
              mb.user_id
             FROM (leaderboards
               JOIN memberships mb ON ((mb.leaderboard_id = leaderboards.id)))
          )
   SELECT matches.id AS match_id,
      matches.round_id,
      matches.competition_id,
      l.id AS leaderboard_id,
      matches.status,
      matches.group_id,
      matches.team_away_id,
      matches.team_home_id,
      matches.next_match_id,
          CASE
              WHEN (((matches.status)::text = 'upcoming'::text) OR ((matches.status)::text = 'started'::text)) THEN NULL::text
              WHEN ((matches.team_home_et_score IS NULL) AND (matches.team_away_et_score IS NULL) AND (matches.team_home_ps_score IS NULL) AND (matches.team_away_ps_score IS NULL) AND (matches.team_home_score = matches.team_away_score)) THEN 'draw'::text
              WHEN ((matches.team_home_score > matches.team_away_score) OR ((matches.team_home_et_score IS NOT NULL) AND (matches.team_home_et_score > matches.team_away_et_score)) OR ((matches.team_home_ps_score IS NOT NULL) AND (matches.team_home_ps_score > matches.team_away_ps_score))) THEN 'home'::text
              ELSE 'away'::text
          END AS winning_side,
      r.number AS round_number,
      r.points,
      r.name AS round_name,
      ARRAY( SELECT DISTINCT p.user_id
             FROM predictions p
            WHERE ((p.match_id = matches.id) AND (p.user_id IN ( SELECT lu.user_id
                     FROM leaderboard_users lu
                    WHERE (lu.id = l.id))) AND ((p.choice)::text = 'home'::text))) AS predicted_home,
      ARRAY( SELECT DISTINCT p.user_id
             FROM predictions p
            WHERE ((p.match_id = matches.id) AND (p.user_id IN ( SELECT lu.user_id
                     FROM leaderboard_users lu
                    WHERE (lu.id = l.id))) AND ((p.choice)::text = 'draw'::text))) AS predicted_draw,
      ARRAY( SELECT DISTINCT p.user_id
             FROM predictions p
            WHERE ((p.match_id = matches.id) AND (p.user_id IN ( SELECT lu.user_id
                     FROM leaderboard_users lu
                    WHERE (lu.id = l.id))) AND ((p.choice)::text = 'away'::text))) AS predicted_away
     FROM ((matches
       JOIN rounds r ON ((matches.round_id = r.id)))
       JOIN leaderboards l ON ((l.competition_id = matches.competition_id)))
    ORDER BY matches.id;
  SQL
  create_view "user_scores", materialized: true, sql_definition: <<-SQL
      WITH prediction_scores AS (
           SELECT DISTINCT p.id AS prediction_id,
              p.user_id,
              p.match_id,
              r.points,
              mr.competition_id,
                  CASE
                      WHEN (((mr.status)::text = 'finished'::text) AND (p.choice IS NOT NULL)) THEN true
                      ELSE false
                  END AS completed,
                  CASE
                      WHEN (((mr.status)::text = 'finished'::text) AND ((p.choice)::text = mr.winning_side)) THEN true
                      ELSE false
                  END AS correct,
                  CASE
                      WHEN (((mr.status)::text = 'finished'::text) AND ((p.choice)::text = mr.winning_side)) THEN mr.points
                      ELSE 0
                  END AS prediction_score
             FROM ((predictions p
               LEFT JOIN match_results mr ON ((mr.match_id = p.match_id)))
               LEFT JOIN rounds r ON ((r.id = mr.round_id)))
          ), prediction_numbers AS (
           SELECT u.id AS user_id,
              ps_1.competition_id,
              sum(ps_1.prediction_score) AS score,
              count(DISTINCT ps_1.prediction_id) AS total_predictions,
              ( SELECT count(DISTINCT ps2.prediction_id) AS count
                     FROM prediction_scores ps2
                    WHERE (ps2.completed IS TRUE)
                    GROUP BY ps2.user_id, ps2.competition_id
                   HAVING ((ps2.user_id = u.id) AND (ps2.competition_id = ps_1.competition_id))) AS completed_predictions,
              ( SELECT count(DISTINCT ps2.prediction_id) AS count
                     FROM prediction_scores ps2
                    WHERE (ps2.correct IS TRUE)
                    GROUP BY ps2.user_id, ps2.competition_id
                   HAVING ((ps2.user_id = u.id) AND (ps2.competition_id = ps_1.competition_id))) AS correct_predictions
             FROM (users u
               LEFT JOIN prediction_scores ps_1 ON ((ps_1.user_id = u.id)))
            GROUP BY u.id, ps_1.competition_id
          )
   SELECT DISTINCT ON (ps.user_id, ps.competition_id) ps.user_id,
      ps.competition_id,
      pn.score,
      (pn.completed_predictions * ps.points) AS max_possible_score,
      pn.total_predictions,
      pn.completed_predictions,
      pn.correct_predictions,
      round((((pn.correct_predictions)::numeric * 1.0) / (NULLIF(pn.total_predictions, 0))::numeric), 3) AS accuracy
     FROM (prediction_scores ps
       JOIN prediction_numbers pn ON (((pn.user_id = ps.user_id) AND (pn.competition_id = ps.competition_id))))
    ORDER BY ps.user_id;
  SQL
  create_view "leaderboard_rankings", materialized: true, sql_definition: <<-SQL
      SELECT DISTINCT ON ((rank() OVER (PARTITION BY l.id ORDER BY us.score DESC, us.accuracy DESC, us.completed_predictions DESC)), us.score, us.accuracy, us.completed_predictions, l.id, l.competition_id, us.user_id) l.id AS leaderboard_id,
      us.user_id,
      us.competition_id,
      us.score,
      us.max_possible_score,
      us.total_predictions,
      us.completed_predictions,
      us.correct_predictions,
      us.accuracy,
      rank() OVER (PARTITION BY l.id ORDER BY us.score DESC, us.accuracy DESC, us.completed_predictions DESC) AS user_rank
     FROM ((leaderboards l
       JOIN memberships m ON ((m.leaderboard_id = l.id)))
       JOIN user_scores us ON (((us.user_id = m.user_id) AND (us.competition_id = l.competition_id))))
    ORDER BY (rank() OVER (PARTITION BY l.id ORDER BY us.score DESC, us.accuracy DESC, us.completed_predictions DESC)), us.score, us.accuracy, us.completed_predictions;
  SQL
end
