from db import Base
from sqlalchemy import DateTime, String, Column, Integer, Numeric, LargeBinary, ForeignKey, text
from uuid import uuid4
import datetime

class User(Base):
     __tablename__ = 'user'
     id = Column(Integer,primary_key=True,nullable=False,  default=lambda: uuid4().hex)
     email = Column(String(255), unique=True, nullable=False)
     _username = Column(String(60), nullable=True)

     @property
     def username(self):
          return self._username
     
     @username.setter
     def username(self, value):
          self._username = value

     password = Column(LargeBinary(60), nullable=False)
     created_at = Column(DateTime, default=datetime.datetime.now)


class Wallet(Base):
    __tablename__ = 'wallet'

    id = Column(Integer,primary_key=True,nullable=False,  default=lambda: uuid4().hex)
    user_id = Column(Integer, ForeignKey("user.id"), nullable=False)
    wallet_address = Column(String(255), unique=True, nullable=False)
    network = Column(String(60), nullable=False)

class Xp(Base):
    __tablename__ = 'xp'

    id = Column(Integer, primary_key=True, nullable=False, default=lambda: uuid4().hex)
    user_id = Column(Integer, ForeignKey("user.id"), nullable=False)
    amount = Column(Integer, nullable=False)
    current_Balance = Column(Integer, nullable=False)
    created_at = Column(DateTime, default=datetime.datetime.now)
    updated_at = Column(DateTime, default=datetime.datetime.now)


class Transaction(Base):
    __tablename__ = 'transaction'

    id = Column(Integer, primary_key=True, nullable=False, default=lambda: uuid4().hex)
    transactionHash = Column(String(255), unique=True, nullable=False)
    amount = Column(Numeric(precision=10, scale=2), nullable=False)
    status = Column(String(255), nullable=True)
    created_at = Column(DateTime, default=datetime.datetime.now)
    category_id = Column(Integer, ForeignKey("category.id"), nullable=False)

class withdrawalRequest(Base):
    __tablename__ = "withdrawalRequest"

    id = Column(Integer, primary_key=True, nullable=False, default=lambda: uuid4().hex)
    user_id = Column(Integer, ForeignKey("user.id"), nullable=False)
    amount = Column(Numeric(precision=10, scale=2), nullable=False)
    transaction_id = Column(Integer, ForeignKey("transaction.id"), nullable=False)
    category_id = Column(Integer, ForeignKey("category.id"), nullable=False)


class Category(Base):
    __tablename__ = "category"

    id = Column(Integer, primary_key=True, nullable=False, default=lambda: uuid4().hex)
    category_name = Column(String(255), nullable=False, default="default_category_name")

class Savings(Base):
    __tablename__ = "savings"


    Goal_id = Column(Integer, primary_key=True, nullable=False,default=lambda: uuid4().hex)
    current_balance = Column(Numeric(precision=10, scale=2), nullable=False)
    target = Column(Numeric(precision=10, scale=2), nullable=False)
    description = Column(String(255), nullable=False, default="default_decription")
    wallet_id = Column(Integer, ForeignKey("wallet.id"), nullable=False)
    timeStamp = Column(DateTime, default=datetime.datetime.now)

