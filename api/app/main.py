from fastapi import FastAPI, HTTPException, status
from pydantic import BaseModel, EmailStr
from typing import List

app = FastAPI()

class ClientBase(BaseModel):
    name: str
    email: EmailStr

class ClientCreate(ClientBase):
    pass

class Client(ClientBase):
    id: int

clients: List[Client] = []
next_id = 1

@app.get("/", tags=["Health"])
async def root():
    return {"message": "API funcionando!"}

@app.post(
    "/clients/",
    response_model=Client,
    status_code=status.HTTP_201_CREATED,
    tags=["Clients"],
    summary="Cria um novo cliente"
)
async def create_client(client: ClientCreate):
    global next_id
    # Verifica se o e-mail já existe
    if any(c.email == client.email for c in clients):
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="E-mail já cadastrado"
        )
    new_client = Client(id=next_id, **client.dict())
    clients.append(new_client)
    next_id += 1
    return new_client

@app.get(
    "/clients/",
    response_model=List[Client],
    tags=["Clients"],
    summary="Lista todos os clientes"
)
async def get_clients():
    return clients

@app.get(
    "/clients/{client_id}",
    response_model=Client,
    tags=["Clients"],
    summary="Busca um cliente pelo ID"
)
async def get_client(client_id: int):
    for client in clients:
        if client.id == client_id:
            return client
    raise HTTPException(
        status_code=status.HTTP_404_NOT_FOUND,
        detail="Cliente não encontrado"
)