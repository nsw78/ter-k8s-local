from fastapi import FastAPI
from pydantic import BaseModel
from typing import List

app = FastAPI()

clients = []

class Client(BaseModel):
    id: int
    name: str
    email: str

@app.get("/")
async def root():
    return {"message": "API funcionando!"}

@app.post("/clients/")
def create_client(client: Client):
    clients.append(client)
    return client

@app.get("/clients/", response_model=List[Client])
def get_clients():
    return clients
