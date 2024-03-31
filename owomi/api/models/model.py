from db import Base
from sqlalchemy import DateTime, String, Column, Integer, Numeric, LargeBinary, ForeignKey
from sqlalchemy.orm import relationship
from uuid import uuid4
from enum import Enum
import datetime


class User(Base):
    __tablename__ = 'user'

    id = Column(Integer, primary_key=True, nullable=False, default=lambda: uuid4().hex)
    _username = Column(String(60), nullable=True, unique=True)
    wallet_address = Column(String(255), unique=True, nullable=False)
    password = Column(LargeBinary(60), nullable=False)
    created_at = Column(DateTime, default=datetime.datetime.now)

    @property
    def username(self):
        return self._username

    @username.setter
    def username(self, value):
        self._username = value

    circles = relationship("Circle", back_populates="user")


class Wallet(Base):
    __tablename__ = 'wallet'

    id = Column(Integer,primary_key=True,nullable=False,  default=lambda: uuid4().hex)
    user_id = Column(Integer, ForeignKey("user.id"), nullable=False)
    
    network = Column(String(60), nullable=False)


class Savings(Base):
    __tablename__ = "savings"

    goal_id = Column(Integer, primary_key=True, nullable=False, default=lambda: uuid4().hex)
    current_balance = Column(Numeric(precision=10, scale=2), nullable=False)
    target = Column(Numeric(precision=10, scale=2), nullable=False)
    description = Column(String(255), nullable=False, default="default_description")
    wallet_id = Column(Integer, ForeignKey("wallet.id"), nullable=False)
    wallet = relationship("Wallet", back_populates="savings")
    category_id = Column(Integer, ForeignKey("category.id"), nullable=False)
    category = relationship("Category", back_populates="savings")
    created_at = Column(DateTime, default=datetime.datetime.now)


class Category(Base):
    __tablename__ = "category"

    id = Column(Integer, primary_key=True, nullable=False, default=lambda: uuid4().hex)
    category_name = Column(String(255), nullable=False, default="default_category_name")
    savings = relationship("Savings", back_populates="category")


class Circle(Base):
    __tablename__ = "circle"

    circle_id = Column(Integer, primary_key=True, nullable=False, default=lambda: uuid4().hex)
    current_balance = Column(Numeric(precision=10, scale=2), nullable=False)
    target_balance = Column(Numeric(precision=10, scale=2), nullable=False)  # Renamed to avoid conflict
    user_id = Column(Integer, ForeignKey("user.id"), nullable=False)
    category_id = Column(Integer, ForeignKey("category.id"), nullable=False)  # New relationship with Category
    title = Column(String(255), nullable=False, default="default_Title")
    description = Column(String(255), nullable=False, default="default_description")
    created_at = Column(DateTime, default=datetime.datetime.now)
    completed_at = Column(DateTime, default=datetime.datetime.now)
    user = relationship("User", back_populates="circles")
    category = relationship("Category", back_populates="circles")


class TokenType(Enum):
  USDC = "USDC"
  USDT = "USDT"

class Token:
  def __init__(self, token_type: TokenType, mint_address: str):
    self.token_type = token_type
    self.mint_address = mint_address