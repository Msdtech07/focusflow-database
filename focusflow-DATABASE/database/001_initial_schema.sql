-- FocusFlow Database Schema
-- Run this against your PostgreSQL database ONCE to set up all tables.
-- Compatible with: Neon, Supabase, Railway PostgreSQL, any standard PostgreSQL 14+

-- ============================================================
-- USERS
-- ============================================================
CREATE TABLE IF NOT EXISTS "users" (
  "id"                  SERIAL PRIMARY KEY,
  "clerk_id"            TEXT NOT NULL UNIQUE,
  "goal_categories"     TEXT[] NOT NULL DEFAULT '{}',
  "onboarding_complete" BOOLEAN NOT NULL DEFAULT FALSE,
  "created_at"          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  "updated_at"          TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================================
-- TASKS
-- ============================================================
CREATE TABLE IF NOT EXISTS "tasks" (
  "id"               SERIAL PRIMARY KEY,
  "user_id"          TEXT NOT NULL,
  "title"            TEXT NOT NULL,
  "due_date"         DATE,
  "priority"         TEXT NOT NULL DEFAULT 'medium'
                       CHECK (priority IN ('high','medium','low')),
  "estimated_hours"  REAL,
  "category"         TEXT,
  "status"           TEXT NOT NULL DEFAULT 'pending'
                       CHECK (status IN ('pending','done','skipped')),
  "source"           TEXT NOT NULL DEFAULT 'manual'
                       CHECK (source IN ('manual','todoist','notion')),
  "external_id"      TEXT,
  "created_at"       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  "updated_at"       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS "tasks_user_id_idx" ON "tasks" ("user_id");
CREATE INDEX IF NOT EXISTS "tasks_user_status_idx" ON "tasks" ("user_id", "status");

-- ============================================================
-- FOCUS SESSIONS
-- ============================================================
CREATE TABLE IF NOT EXISTS "focus_sessions" (
  "id"         SERIAL PRIMARY KEY,
  "user_id"    TEXT NOT NULL,
  "date"       DATE NOT NULL,
  "created_at" TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE ("user_id", "date")
);

CREATE INDEX IF NOT EXISTS "focus_sessions_user_id_idx" ON "focus_sessions" ("user_id");

-- ============================================================
-- FOCUS ITEMS  (the Top 3 tasks inside a session)
-- ============================================================
CREATE TABLE IF NOT EXISTS "focus_items" (
  "id"           SERIAL PRIMARY KEY,
  "session_id"   INTEGER NOT NULL REFERENCES "focus_sessions"("id") ON DELETE CASCADE,
  "task_id"      INTEGER NOT NULL REFERENCES "tasks"("id") ON DELETE CASCADE,
  "rank"         INTEGER NOT NULL,
  "ai_reasoning" TEXT NOT NULL,
  "status"       TEXT NOT NULL DEFAULT 'pending'
                   CHECK (status IN ('pending','done','skipped')),
  "created_at"   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  "updated_at"   TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS "focus_items_session_id_idx" ON "focus_items" ("session_id");

-- ============================================================
-- REFLECTIONS
-- ============================================================
CREATE TABLE IF NOT EXISTS "reflections" (
  "id"              SERIAL PRIMARY KEY,
  "user_id"         TEXT NOT NULL,
  "date"            DATE NOT NULL,
  "note"            TEXT NOT NULL DEFAULT '',
  "completed_count" INTEGER NOT NULL DEFAULT 0,
  "skipped_count"   INTEGER NOT NULL DEFAULT 0,
  "created_at"      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  "updated_at"      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE ("user_id", "date")
);

CREATE INDEX IF NOT EXISTS "reflections_user_id_idx" ON "reflections" ("user_id");
