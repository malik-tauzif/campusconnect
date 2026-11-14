-- Safe registration: locks the event row so two people can't take the last seat
CREATE OR REPLACE FUNCTION register_for_event(p_user_id uuid, p_event_id uuid)
RETURNS uuid
LANGUAGE plpgsql
AS $$
DECLARE
  v_event events%ROWTYPE;
  v_count integer;
  v_id    uuid;
BEGIN
  -- 1. Lock the event row. A second request for the same event waits here.
  SELECT * INTO v_event FROM events WHERE id = p_event_id FOR UPDATE;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'EVENT_NOT_FOUND';
  END IF;

  -- 2. Event must be open
  IF v_event.status <> 'open' THEN
    RAISE EXCEPTION 'EVENT_CLOSED';
  END IF;

  -- 3. No duplicate registration
  IF EXISTS (SELECT 1 FROM registrations
             WHERE user_id = p_user_id AND event_id = p_event_id) THEN
    RAISE EXCEPTION 'DUPLICATE_REGISTRATION';
  END IF;

  -- 4. Capacity check (sees every committed booking, because we hold the lock)
  SELECT count(*) INTO v_count FROM registrations WHERE event_id = p_event_id;
  IF v_count >= v_event.capacity THEN
    RAISE EXCEPTION 'EVENT_FULL';
  END IF;

  -- 5. Save
  INSERT INTO registrations (user_id, event_id)
  VALUES (p_user_id, p_event_id)
  RETURNING id INTO v_id;

  RETURN v_id;

EXCEPTION
  WHEN unique_violation THEN
    RAISE EXCEPTION 'DUPLICATE_REGISTRATION';
END;
$$;

-- Tell Supabase's API to pick up the new function
NOTIFY pgrst, 'reload schema';