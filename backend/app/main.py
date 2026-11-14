from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.routes import router

app = FastAPI(
    title="CampusConnect API",
    description="Backend for the CampusConnect event registration app",
    version="1.0.0",
)

# Allow the React frontend (a different address) to call this API
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(router)


@app.get("/", summary="Health check")
def health_check():
    return {"status": "online", "service": "CampusConnect Backend", "docs_url": "/docs"}

