from fastapi import APIRouter, HTTPException
from app.config import connection_uri, queries
from app.services.metadata_service import generate_metadata

router = APIRouter()

@router.get("/metadata/generate")
async def generate_db_metadata():
    try:
        metadata = generate_metadata(queries)
        return metadata
    
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

