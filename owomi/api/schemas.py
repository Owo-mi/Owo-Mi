from pydantic import BaseModel
from typing import List
import datetime

class UserBase(BaseModel):
    username: str
    wallet_address: str
    pin: int

class UserPinAuthentication(BaseModel):
    username: str 
    pin: int
    
class UserResponse(UserBase):
    id: int

    class Config:
         orm_mode: True
         
class TokenResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"

class WalletBase(BaseModel):
     wallet_address: List[str]
     network: List[str]

     class Config:
         orm_mode: True


class CategoryBase(BaseModel):
    category_name: List[str]


class SavingsBase(BaseModel):
     goal_id: List[int]
     current_balance: int
     date: datetime.datetime
     

class SavingsCreate(BaseModel):
    goal_id: int
    initial_balance: int
    created_date:datetime.datetime


class CircleCreate(BaseModel):
     title: str
     description: str | None = None
     initial_balance: int
     target: int
     initial_count: int
     target: int
     created_at: datetime.datetime
     completed_at: datetime.datetime


class CircleBase(CircleCreate):
     circle_id: int
     current_balance: int
     user_count: int
     created_at: datetime.datetime
     completed_at: datetime.datetime

     class Config:
         orm_mode: True

     


    

