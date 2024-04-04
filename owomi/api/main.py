from fastapi import FastAPI, Request, HTTPException, Depends, Header, status, Body
from db import Base, engine, SessionLocal
from anchor_client import create_program_client
from pydantic import BaseModel
from typing import List, Annotated, Optional
from model import User, Savings, Circle, Category
from schemas import UserBase, UserPinAuthentication, TokenResponse
from decouple import config
from jose import JWTError, jwt
from datetime import datetime, timedelta
from fastapi.security import OAuth2PasswordBearer
from fastapi.params import Query 
from sqlalchemy.orm import Session

app = FastAPI()
Base.metadata.create_all(bind=engine)

# OAUTH hashing algorithm
ALGORITHM="RS256"

DEV_API_SECRET_KEY= config('DEV_API_SECRET_KEY')
DEV_OAUTH_PATH = config('DEV_OAUTH_KEY')

with open(DEV_OAUTH_PATH, "rb") as f:
    DEV_OAUTH_KEY = f.read()

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


async def get_program_client():
    program = await create_program_client()
    return program

# in-routes functions(should be moved to another file for neatness)
# create owomi account
def create_user(db_session, user_data: UserBase):
    db_user = User(**user_data.dict())
    db_session.add(db_user)
    db_session.commit()
    db_session.refresh(db_user)
    return db_user


async def get_user(db: Session, username: str):
    user = db.query(User).filter(User.username == username).first()
    return user

# api authenthication , so we have to include it Authorization Header: Include the API key in an Authorization: Bearer <your_key> header. 
#Query Parameter: Pass the API key as a query parameter (?api_key=<DEV_API_SECRET_KEY>). 
async def api_key_auth(api_key: str = None):
    if api_key != DEV_API_SECRET_KEY:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Invalid API key")

async def authenticate_user(username: str, pin: int, db=Depends(get_db)):
    user = await get_user(db, username)  # Retrieve user based on username
    if not user:
        return None  # User not found
    # password hashing logic (we can replace it hasing implementation later)
    # if user.hashed_pin == hash_pin(pin):
    if user.pin == pin:  # Assuming pin is not hashed
        return user
    return None  # Invalid pin
    

# Access token generation
ACCESS_TOKEN_EXPIRE_MINUTES = 30 
async def create_access_token(user: User):
    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    to_encode = {"sub": user.username, "exp": datetime.utcnow() + access_token_expires, "user_id": user.id}
    encoded_jwt = jwt.encode(to_encode, DEV_OAUTH_KEY, algorithm=ALGORITHM)
    return encoded_jwt

# OAuth2 scheme for token-based authentication
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/token")
async def fetch_current_user(token: str = Depends(oauth2_scheme), oauth2_scheme: OAuth2PasswordBearer = Depends()) -> Optional[User]:
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )

    try:
        payload = oauth2_scheme.verify_required(token)  # Use oauth2_scheme to verify token
        username: str = payload.get("sub")
        if username is None:
            raise credentials_exception
        # Fetch user from database based on username
        user = await get_user(db, username=username)  # Replace with your user retrieval logic

        if user is None:
            raise credentials_exception
        return user
    except JWTError:
        raise credentials_exception



# POST, GET, PUT, DELETE , UPDATE... routes
@app.get("/")
async def message():
    return {"message": "Owo Mi!!!"}

# Use api dependency in your route handlers
@app.get("/protected-resource")                 #include authorization: bearer <access token> in headers to authenticate user.
async def protected_resource(current_user: User = Depends(oauth2_scheme)):
    #test if oauth login auth key is working
    return {"message": "You have access!"}


#POST /create-user?api_key=#############mkwybididyhcejkzwtc
@app.post("/create-user")
async def create_user_route(user_data: UserBase, db=Depends(get_db), api_key: str = Depends(api_key_auth)):
    user = create_user(db, user_data)
    return user

@app.post("/login")     #generates  authorization: bearer <access token> to include in headers
async def login(login_data: UserPinAuthentication = Body(...), db=Depends(get_db)):
    user = await authenticate_user(login_data.username, login_data.pin, db)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid username or pin"
        )
    access_token = await create_access_token(user)
    return TokenResponse(access_token=access_token, token_type="bearer")

# Retrieve the currently authenticated user's profile information. 
# every route that included 
@app.get("/me")
async def get_current_user(current_user: User = Depends(oauth2_scheme)):
    return current_user # only bearer auth Return token, fix it to return usernameor wallet_addr..
