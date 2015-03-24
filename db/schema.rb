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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 14) do

  create_table "articles", force: :cascade do |t|
    t.integer  "source_id",   limit: 4
    t.text     "link",        limit: 65535
    t.text     "title",       limit: 65535,                 null: false
    t.text     "description", limit: 65535
    t.boolean  "published",   limit: 1,     default: false, null: false
    t.boolean  "commentable", limit: 1,     default: true,  null: false
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  add_index "articles", ["source_id"], name: "index_articles_on_source_id", using: :btree

  create_table "categories", force: :cascade do |t|
    t.integer  "article_id", limit: 4
    t.integer  "parent_id",  limit: 4
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "categories", ["article_id"], name: "index_categories_on_article_id", using: :btree
  add_index "categories", ["name"], name: "index_categories_on_name", using: :btree
  add_index "categories", ["parent_id"], name: "index_categories_on_parent_id", using: :btree

  create_table "comments", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "article_id", limit: 4
    t.text     "body",       limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "comments", ["article_id"], name: "index_comments_on_article_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "definitions", force: :cascade do |t|
    t.integer  "word_id",    limit: 4,     null: false
    t.text     "value",      limit: 65535
    t.integer  "rank",       limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "definitions", ["rank"], name: "index_definitions_on_rank", using: :btree
  add_index "definitions", ["word_id"], name: "index_definitions_on_word_id", using: :btree

  create_table "learned_words", force: :cascade do |t|
    t.integer  "user_id",    limit: 4, null: false
    t.integer  "word_id",    limit: 4, null: false
    t.integer  "status",     limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "learned_words", ["user_id"], name: "index_learned_words_on_user_id", using: :btree
  add_index "learned_words", ["word_id"], name: "index_learned_words_on_word_id", using: :btree

  create_table "sentences", force: :cascade do |t|
    t.integer  "article_id", limit: 4,     null: false
    t.integer  "rank",       limit: 4,     null: false
    t.text     "value",      limit: 65535, null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "sentences", ["article_id", "rank"], name: "index_sentences_on_article_id_and_rank", unique: true, using: :btree
  add_index "sentences", ["article_id"], name: "index_sentences_on_article_id", using: :btree

  create_table "sources", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.string   "link",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "sources", ["name"], name: "index_sources_on_name", unique: true, using: :btree

  create_table "taggings", force: :cascade do |t|
    t.integer  "taggable_id",   limit: 4
    t.string   "taggable_type", limit: 255
    t.integer  "tag_id",        limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "tags", ["name"], name: "index_tags_on_name", using: :btree

  create_table "tokens", force: :cascade do |t|
    t.integer  "sentence_id", limit: 4,     null: false
    t.integer  "word_id",     limit: 4,     null: false
    t.integer  "rank",        limit: 4
    t.text     "notes",       limit: 65535
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "tokens", ["sentence_id", "rank"], name: "index_tokens_on_sentence_id_and_rank", unique: true, using: :btree
  add_index "tokens", ["sentence_id"], name: "index_tokens_on_sentence_id", using: :btree
  add_index "tokens", ["word_id"], name: "index_tokens_on_word_id", using: :btree

  create_table "translations", force: :cascade do |t|
    t.string   "value",       limit: 255, null: false
    t.integer  "source_id",   limit: 4
    t.integer  "user_id",     limit: 4
    t.integer  "sentence_id", limit: 4
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "translations", ["sentence_id"], name: "index_translations_on_sentence_id", using: :btree
  add_index "translations", ["source_id"], name: "index_translations_on_source_id", using: :btree
  add_index "translations", ["user_id"], name: "index_translations_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.integer  "failed_attempts",        limit: 4,   default: 0,  null: false
    t.string   "unlock_token",           limit: 255
    t.datetime "locked_at"
    t.integer  "role",                   limit: 4,                null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

  create_table "words", force: :cascade do |t|
    t.integer  "category",            limit: 4,   null: false
    t.string   "simplified",          limit: 255, null: false
    t.string   "traditional",         limit: 255
    t.string   "pinyin",              limit: 255
    t.string   "pinyin_cs",           limit: 255
    t.integer  "hsk_character_level", limit: 4
    t.integer  "hsk_word_level",      limit: 4
    t.integer  "character_frequency", limit: 4
    t.integer  "word_frequency",      limit: 4
    t.integer  "radical_number",      limit: 4
    t.integer  "strokes",             limit: 4
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "words", ["category"], name: "index_words_on_category", using: :btree
  add_index "words", ["character_frequency"], name: "index_words_on_character_frequency", using: :btree
  add_index "words", ["hsk_character_level"], name: "index_words_on_hsk_character_level", using: :btree
  add_index "words", ["hsk_word_level"], name: "index_words_on_hsk_word_level", using: :btree
  add_index "words", ["pinyin"], name: "index_words_on_pinyin", using: :btree
  add_index "words", ["pinyin_cs"], name: "index_words_on_pinyin_cs", using: :btree
  add_index "words", ["radical_number"], name: "index_words_on_radical_number", using: :btree
  add_index "words", ["simplified"], name: "index_words_on_simplified", using: :btree
  add_index "words", ["strokes"], name: "index_words_on_strokes", using: :btree
  add_index "words", ["traditional"], name: "index_words_on_traditional", using: :btree
  add_index "words", ["word_frequency"], name: "index_words_on_word_frequency", using: :btree

  add_foreign_key "articles", "sources"
  add_foreign_key "comments", "articles"
  add_foreign_key "comments", "users"
  add_foreign_key "definitions", "words"
  add_foreign_key "learned_words", "users"
  add_foreign_key "learned_words", "words"
  add_foreign_key "sentences", "articles"
  add_foreign_key "tokens", "sentences"
  add_foreign_key "tokens", "words"
  add_foreign_key "translations", "sentences"
  add_foreign_key "translations", "sources"
  add_foreign_key "translations", "users"
end
