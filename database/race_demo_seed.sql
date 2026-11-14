-- 20 fictional racer users + a 5-seat event for the Last-Seat race demo
INSERT INTO users (id, email, role)
SELECT ('00000000-0000-0000-0000-' || lpad(n::text, 12, '0'))::uuid,
       'racer' || n || '@campus.edu', 'student'
FROM generate_series(1, 20) AS n
ON CONFLICT (id) DO NOTHING;

INSERT INTO events (id, organizer_id, title, capacity, status) VALUES
  ('550e8400-e29b-41d4-a716-446655440099', '11111111-1111-1111-1111-111111111111', 'Last Seat Demo', 5, 'open')
ON CONFLICT (id) DO NOTHING;

-- Run this before each demo to empty the 5 seats again:
-- DELETE FROM registrations WHERE event_id = '550e8400-e29b-41d4-a716-446655440099';