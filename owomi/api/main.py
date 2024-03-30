from fastapi import FastAPI, Request, HTTPException 
from db import Base, engine, SessionLocal
from pydantic import BaseModel
from typing import List, Annotated
from models import User, Savings, Circle, Category


app = FastAPI()
Base.metadata.create_all(bind=engine)


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


@app.get("/")
async def message():
    return {"message": "Owo Mi!!!"}
