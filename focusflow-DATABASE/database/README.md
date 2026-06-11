# FocusFlow — Database Setup

## Option A — Neon (Recommended, Free)

1. Go to https://neon.tech → Create account → New Project → name it "focusflow"
2. Copy the **Connection String** (looks like `postgresql://user:pass@ep-xxx.neon.tech/neondb?sslmode=require`)
3. Open the **SQL Editor** tab in Neon dashboard
4. Paste the entire contents of `001_initial_schema.sql` and click **Run**
5. Done ✅ — use the connection string as your `DATABASE_URL`

## Option B — Supabase (Free)

1. Go to https://supabase.com → New Project
2. Go to **SQL Editor** → New Query
3. Paste the contents of `001_initial_schema.sql` → Run
4. Go to **Settings → Database → Connection string → URI**
5. Use that as your `DATABASE_URL`

## Option C — Railway PostgreSQL

1. In your Railway project → **New** → **Database** → **PostgreSQL**
2. Click the database → **Connect** tab → copy **DATABASE_URL**
3. Open **Query** tab → paste `001_initial_schema.sql` → Run
4. Use the `DATABASE_URL` directly — Railway injects it automatically if backend is in same project

## Option D — Local PostgreSQL

```bash
psql -U postgres -c "CREATE DATABASE focusflow;"
psql -U postgres -d focusflow -f 001_initial_schema.sql
```

Connection string: `postgresql://postgres:yourpassword@localhost:5432/focusflow`

---

## Re-running safely

The SQL uses `CREATE TABLE IF NOT EXISTS` so it is **safe to run multiple times** — it won't duplicate or delete any data.

## Resetting (wipe all data)

```sql
DROP TABLE IF EXISTS focus_items CASCADE;
DROP TABLE IF EXISTS focus_sessions CASCADE;
DROP TABLE IF EXISTS reflections CASCADE;
DROP TABLE IF EXISTS tasks CASCADE;
DROP TABLE IF EXISTS users CASCADE;
```

Then re-run `001_initial_schema.sql`.
