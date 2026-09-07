from fastapi import FastAPI
from datetime import datetime

app = FastAPI(title="slsa-lab-app")

@app.get("/health")
def health():
    return {"status": "ok", "time": datetime.utcnow().isoformat()}

@app.get("/")
def root():
    return {"service": "slsa-provenance-lab", "version": "0.1.0"}
