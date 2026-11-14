"""Fire 20 registrations at the 'Last Seat Demo' event (capacity 5) at the same moment.
Usage:  python race_test.py                      (local backend on port 8001)
        python race_test.py https://<your-service>.onrender.com/api
"""
import json
import sys
import urllib.error
import urllib.request
from concurrent.futures import ThreadPoolExecutor

API = sys.argv[1] if len(sys.argv) > 1 else "http://localhost:8001/api"
EVENT_ID = "550e8400-e29b-41d4-a716-446655440099"
CAPACITY = 5
STUDENTS = 20


def register(n):
    user_id = f"00000000-0000-0000-0000-{n:012d}"
    req = urllib.request.Request(
        f"{API}/registrations",
        data=json.dumps({"event_id": EVENT_ID}).encode(),
        headers={"Content-Type": "application/json", "x-user-id": user_id},
        method="POST",
    )
    try:
        with urllib.request.urlopen(req, timeout=60) as r:
            return r.status
    except urllib.error.HTTPError as e:
        return e.code


with ThreadPoolExecutor(max_workers=STUDENTS) as pool:
    codes = list(pool.map(register, range(1, STUDENTS + 1)))

print("Status codes:", codes)
print(f"Seats booked: {codes.count(201)}  (capacity {CAPACITY})")
print("OVERBOOKED!" if codes.count(201) > CAPACITY else "Capacity respected.")