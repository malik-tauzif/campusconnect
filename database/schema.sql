-- CampusConnect: database schema + sample data
-- WARNING: running this file DELETES existing tables and data. Use it only to rebuild from scratch.

DROP TABLE IF EXISTS registrations CASCADE;
DROP TABLE IF EXISTS events CASCADE;
DROP TABLE IF EXISTS users CASCADE;

CREATE TABLE users (
    id    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email TEXT UNIQUE NOT NULL,
    role  TEXT NOT NULL DEFAULT 'student' CHECK (role IN ('student', 'organizer', 'admin'))
);

CREATE TABLE events (
    id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organizer_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    title        TEXT NOT NULL,
    capacity     INTEGER NOT NULL CHECK (capacity > 0),
    status       TEXT NOT NULL DEFAULT 'open' CHECK (status IN ('open', 'closed'))
);

-- Junction table: UNIQUE stops a student registering twice
CREATE TABLE registrations (
    id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id    UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    event_id   UUID NOT NULL REFERENCES events(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (user_id, event_id)
);

-- Workshop simplicity: Row Level Security off
ALTER TABLE users         DISABLE ROW LEVEL SECURITY;
ALTER TABLE events        DISABLE ROW LEVEL SECURITY;
ALTER TABLE registrations DISABLE ROW LEVEL SECURITY;

-- Sample users (fictional)
INSERT INTO users (id, email, role) VALUES
  ('11111111-1111-1111-1111-111111111111', 'organizer@campus.edu', 'organizer'),
  ('22222222-2222-2222-2222-222222222222', 'student1@campus.edu',  'student'),
  ('33333333-3333-3333-3333-333333333333', 'student2@campus.edu',  'student'),
  ('44444444-4444-4444-4444-444444444444', 'student3@campus.edu',  'student');

-- Sample events
INSERT INTO events (id, organizer_id, title, capacity, status) VALUES
  ('550e8400-e29b-41d4-a716-446655440000', '11111111-1111-1111-1111-111111111111', 'AI Build Night',   50,  'open'),
  ('550e8400-e29b-41d4-a716-446655440001', '11111111-1111-1111-1111-111111111111', 'Robotics Sprint',  30,  'open'),
  ('550e8400-e29b-41d4-a716-446655440002', '11111111-1111-1111-1111-111111111111', 'Open Source Jam',  100, 'open');