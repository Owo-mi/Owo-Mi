from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from decouple import config

# env secrets
DB_USER = config('DB_USER')
DB_PASSWORD = config('DB_PASSWORD')
DB_NAME = config('DB_NAME')

#checks env if aws is available else use local postgres server
SQLALCHEMY_DATABASE_URL = config("AWS_DB_URL", default="postgresql://{DB_USER}:{DB_PASSWORD}@localhost:5432/{DB_NAME}")

engine = create_engine(SQLALCHEMY_DATABASE_URL)

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()
