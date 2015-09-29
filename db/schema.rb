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

ActiveRecord::Schema.define(version: 27) do

  create_table "articles", force: :cascade do |t|
    t.integer  "source_id",   limit: 4
    t.integer  "category_id", limit: 4
    t.integer  "iframe_id",   limit: 4
    t.integer  "image_id",    limit: 4
    t.text     "title",       limit: 65535,                 null: false
    t.text     "description", limit: 65535
    t.boolean  "published",   limit: 1,     default: false, null: false
    t.boolean  "commentable", limit: 1,     default: true,  null: false
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  add_index "articles", ["category_id"], name: "index_articles_on_category_id", using: :btree
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
    t.integer  "user_id",          limit: 4
    t.integer  "commentable_id",   limit: 4
    t.string   "commentable_type", limit: 255
    t.text     "body",             limit: 65535
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_index "comments", ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id", using: :btree
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

  create_table "iframes", force: :cascade do |t|
    t.integer  "source_id",  limit: 4
    t.string   "url",        limit: 255
    t.string   "title",      limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "learned_words", force: :cascade do |t|
    t.integer  "user_id",    limit: 4, null: false
    t.integer  "word_id",    limit: 4, null: false
    t.integer  "status",     limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "learned_words", ["user_id"], name: "index_learned_words_on_user_id", using: :btree
  add_index "learned_words", ["word_id"], name: "index_learned_words_on_word_id", using: :btree

  create_table "photos", force: :cascade do |t|
    t.integer  "source_id",   limit: 4
    t.string   "file",        limit: 255
    t.string   "title",       limit: 255
    t.text     "description", limit: 65535
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "sections", force: :cascade do |t|
    t.integer  "article_id",    limit: 4
    t.integer  "resource_id",   limit: 4
    t.string   "resource_type", limit: 255
    t.integer  "rank",          limit: 4
    t.string   "classes",       limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "sentences", force: :cascade do |t|
    t.text     "value",          limit: 65535,                 null: false
    t.boolean  "translatable",   limit: 1,     default: false, null: false
    t.boolean  "auto_translate", limit: 1,     default: false, null: false
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
  end

  create_table "snippets", force: :cascade do |t|
    t.text     "content",    limit: 65535
    t.integer  "category",   limit: 4,     null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "sources", force: :cascade do |t|
    t.integer  "article_id", limit: 4
    t.string   "name",       limit: 255,                 null: false
    t.string   "link",       limit: 255
    t.boolean  "disabled",   limit: 1,   default: false
    t.boolean  "restricted", limit: 1,   default: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  add_index "sources", ["name"], name: "index_sources_on_name", unique: true, using: :btree

  create_table "taggings", force: :cascade do |t|
    t.integer  "taggable_id",   limit: 4
    t.string   "taggable_type", limit: 255
    t.integer  "tag_id",        limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "taggings", ["tag_id"], name: "fk_rails_1d6e877cf1", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "tags", ["name"], name: "index_tags_on_name", using: :btree

  create_table "tokens", force: :cascade do |t|
    t.integer  "sentence_id", limit: 4, null: false
    t.integer  "word_id",     limit: 4, null: false
    t.integer  "rank",        limit: 4, null: false
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "tokens", ["sentence_id", "rank"], name: "index_tokens_on_sentence_id_and_rank", unique: true, using: :btree
  add_index "tokens", ["sentence_id"], name: "index_tokens_on_sentence_id", using: :btree
  add_index "tokens", ["word_id"], name: "index_tokens_on_word_id", using: :btree

  create_table "translations", force: :cascade do |t|
    t.text     "value",                   limit: 65535,               null: false
    t.integer  "user_id",                 limit: 4
    t.integer  "sentence_id",             limit: 4
    t.boolean  "category",                limit: 1
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.integer  "cached_votes_total",      limit: 4,     default: 0
    t.integer  "cached_votes_score",      limit: 4,     default: 0
    t.integer  "cached_votes_up",         limit: 4,     default: 0
    t.integer  "cached_votes_down",       limit: 4,     default: 0
    t.integer  "cached_weighted_score",   limit: 4,     default: 0
    t.integer  "cached_weighted_total",   limit: 4,     default: 0
    t.float    "cached_weighted_average", limit: 24,    default: 0.0
  end

  add_index "translations", ["cached_votes_down"], name: "index_translations_on_cached_votes_down", using: :btree
  add_index "translations", ["cached_votes_score"], name: "index_translations_on_cached_votes_score", using: :btree
  add_index "translations", ["cached_votes_total"], name: "index_translations_on_cached_votes_total", using: :btree
  add_index "translations", ["cached_votes_up"], name: "index_translations_on_cached_votes_up", using: :btree
  add_index "translations", ["cached_weighted_average"], name: "index_translations_on_cached_weighted_average", using: :btree
  add_index "translations", ["cached_weighted_score"], name: "index_translations_on_cached_weighted_score", using: :btree
  add_index "translations", ["cached_weighted_total"], name: "index_translations_on_cached_weighted_total", using: :btree
  add_index "translations", ["sentence_id"], name: "index_translations_on_sentence_id", using: :btree
  add_index "translations", ["user_id"], name: "index_translations_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",           limit: 255, null: false
    t.string   "username",        limit: 255, null: false
    t.string   "password_digest", limit: 255, null: false
    t.integer  "role",            limit: 4,   null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  create_table "votes", force: :cascade do |t|
    t.integer  "votable_id",   limit: 4
    t.string   "votable_type", limit: 255
    t.integer  "voter_id",     limit: 4
    t.string   "voter_type",   limit: 255
    t.boolean  "vote_flag",    limit: 1
    t.string   "vote_scope",   limit: 255
    t.integer  "vote_weight",  limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope", using: :btree
  add_index "votes", ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope", using: :btree

  create_table "words", force: :cascade do |t|
    t.integer  "category",            limit: 4,                   null: false
    t.string   "simplified",          limit: 255,                 null: false
    t.string   "traditional",         limit: 255
    t.string   "pinyin",              limit: 255
    t.string   "pinyin_cs",           limit: 255
    t.integer  "hsk_character_level", limit: 4
    t.integer  "hsk_word_level",      limit: 4
    t.integer  "character_frequency", limit: 4
    t.integer  "word_frequency",      limit: 4
    t.integer  "radical_number",      limit: 4
    t.integer  "strokes",             limit: 4
    t.boolean  "noun",                limit: 1,   default: false
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_index "words", ["category"], name: "index_words_on_category", using: :btree
  add_index "words", ["character_frequency"], name: "index_words_on_character_frequency", using: :btree
  add_index "words", ["hsk_character_level"], name: "index_words_on_hsk_character_level", using: :btree
  add_index "words", ["hsk_word_level"], name: "index_words_on_hsk_word_level", using: :btree
  add_index "words", ["noun"], name: "index_words_on_noun", using: :btree
  add_index "words", ["pinyin"], name: "index_words_on_pinyin", using: :btree
  add_index "words", ["pinyin_cs"], name: "index_words_on_pinyin_cs", using: :btree
  add_index "words", ["radical_number"], name: "index_words_on_radical_number", using: :btree
  add_index "words", ["simplified"], name: "index_words_on_simplified", using: :btree
  add_index "words", ["strokes"], name: "index_words_on_strokes", using: :btree
  add_index "words", ["traditional"], name: "index_words_on_traditional", using: :btree
  add_index "words", ["word_frequency"], name: "index_words_on_word_frequency", using: :btree

  add_foreign_key "articles", "categories"
  add_foreign_key "articles", "sources"
  add_foreign_key "comments", "users"
  add_foreign_key "definitions", "words"
  add_foreign_key "learned_words", "users"
  add_foreign_key "learned_words", "words"
  add_foreign_key "taggings", "tags"
  add_foreign_key "tokens", "sentences"
  add_foreign_key "tokens", "words"
  add_foreign_key "translations", "sentences"
  add_foreign_key "translations", "users"
end
