from pydantic import BaseModel
from typing import List
import datetime

class UserBase(BaseModel):
    email: str
    username: str
    password: str

    class Config:
         orm_mode: True

class WalletBase(BaseModel):
     wallet_address: List[str]
     email: str
     network: List[str]

     class Config:
         orm_mode: True

class XpBase(BaseModel):
     user_id: str
     amount: int
     current_Balance: int
     status: str


class CategoryBase(BaseModel):
     category_name = List[str]


class SavingsBase(BaseModel):
     goal_id: List[int]
     current_balance: int
     date: datetime.datetime
     

class SavingsCreate(BaseModel):
    goal_id: int
    initial_balance: int
    created_date:datetime.datetime


    
     


    

