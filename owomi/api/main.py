from fastapi import FastAPI 

app = FastAPI()

@app.get("/")
async def message():
    return {"message": "Owo Mi!!!"}
