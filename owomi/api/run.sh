#!/bin/bash

#run owomi api server

source .venv/bin/activate
uvicorn main:app --host 0.0.0.0 --port 8000