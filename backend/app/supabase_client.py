import os

from dotenv import load_dotenv
from supabase import Client, create_client

# Read SUPABASE_URL and SUPABASE_KEY from the .env file
load_dotenv()

SUPABASE_URL = os.getenv("SUPABASE_URL", "").strip()
SUPABASE_KEY = os.getenv("SUPABASE_KEY", "").strip()

if not SUPABASE_URL or not SUPABASE_KEY:
    raise RuntimeError("Missing SUPABASE_URL or SUPABASE_KEY in backend/.env")

# One shared client that every route uses to talk to the database
supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)