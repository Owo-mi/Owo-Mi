from fastapi import FastAPI, Request, HTTPException, Depends
from db import Base, engine, SessionLocal
from anchor_client import create_program_client
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


async def get_program_client():
    program = await create_program_client()
    return program

@app.get("/")
async def message():
    return {"message": "Owo Mi!!!"}


