from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from app.config import connection_uri, queries
from app.models.data.postgres_local import PostgresLocal
from app.services.metadata_service import generate_metadata
from app.config import connection_uri, queries
from app.services.metadata_service import generate_metadata
from app.services.query_service import generate_query

import requests
import json


class Credentials(BaseModel):
    host: str
    user: str
    password: str
    database: str
    port : str

class QueryRequest(BaseModel):
    query: str 
    model: str
    dbms: str
    credentials: Credentials

router = APIRouter()


@router.post("/query")
async def send_query(request: QueryRequest):

    nlp_query = request.query
    model = request.model
    dbms = request.dbms

    print(f"NLP Query: {nlp_query}")
    print(f"Model : {model}")
    print(f"Database : {dbms}")
    
    credentials = request.credentials
    my_db = PostgresLocal(credentials.host,credentials.user, credentials.password, credentials.database)
    sql_queries= generate_query(nlp_query, model, dbms, my_db.connection_uri)
    my_db.connect()
    results = my_db.run_queries(sql_queries)

    return {"query" : sql_queries, "results" : results}


